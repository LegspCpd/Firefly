import type { APIRoute } from 'astro';

// 配置边缘运行时，完美适配Vercel部署
export const prerender = false;
export const runtime = 'edge';

// 目标GitHub地址
const TARGET_BASE = 'https://github.com';
// 改成你自己的博客域名！！！
const YOUR_BLOG_DOMAIN = 'blog.legspcpd.indevs.in';

export const GET: APIRoute = async ({ params, request }) => {
  try {
    // 1. 获取完整的请求路径
    const fullPath = params.path || '';
    const requestUrl = new URL(request.url);
    
    // 2. 构建要代理的GitHub目标URL
    const targetUrl = new URL(`/${fullPath}`, TARGET_BASE);
    // 保留原请求的查询参数
    targetUrl.search = requestUrl.search;

    // 3. 转发请求到GitHub
    const proxyResponse = await fetch(targetUrl.toString(), {
      method: request.method,
      headers: {
        // 模拟浏览器请求，避免被GitHub拦截
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
        'Accept': request.headers.get('accept') || 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
        'Accept-Language': request.headers.get('accept-language') || 'zh-CN,zh;q=0.9,en;q=0.8',
      },
      redirect: 'manual',
    });

    // 4. 处理响应内容，替换链接为你的域名
    let responseBody = await proxyResponse.text();
    // 把页面里所有GitHub的链接，替换成你博客的/gh/路径
    responseBody = responseBody.replaceAll('https://github.com', `https://${YOUR_BLOG_DOMAIN}/gh`);
    // 替换RAW文件链接，支持直接查看raw内容
    responseBody = responseBody.replaceAll('https://raw.githubusercontent.com', `https://${YOUR_BLOG_DOMAIN}/gh/raw`);

    // 5. 返回处理后的响应
    return new Response(responseBody, {
      status: proxyResponse.status,
      statusText: proxyResponse.statusText,
      headers: {
        'Content-Type': proxyResponse.headers.get('content-type') || 'text/html; charset=utf-8',
        'Cache-Control': 'public, max-age=1800',
        'X-Frame-Options': 'SAMEORIGIN',
      },
    });
  } catch (error) {
    return new Response(`代理失败: ${(error as Error).message}`, {
      status: 500,
    });
  }
};

// 支持POST等其他方法，避免部分功能失效
export const POST: APIRoute = GET;
export const PUT: APIRoute = GET;
export const DELETE: APIRoute = GET;