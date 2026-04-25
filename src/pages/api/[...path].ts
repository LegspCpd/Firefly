import type { APIRoute } from 'astro';

// 必须加！告诉Astro这个路由是动态渲染的，不静态生成
export const prerender = false;
// Vercel边缘运行时，保证速度
export const runtime = 'edge';

// GitHub目标地址
const TARGET_BASE = 'https://github.com';
// 你的博客域名，不要加https://和末尾斜杠
const YOUR_DOMAIN = 'blog.legspcpd.indevs.in';

export const GET: APIRoute = async ({ params, request }) => {
  try {
    // 1. 获取完整的路径
    const fullPath = params.path || '';
    const requestUrl = new URL(request.url);

    // 2. 构建GitHub目标URL，保留查询参数
    const targetUrl = new URL(`/${fullPath}`, TARGET_BASE);
    targetUrl.search = requestUrl.search;

    // 3. 转发请求到GitHub
    const proxyResponse = await fetch(targetUrl.toString(), {
      method: request.method,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
        'Accept': request.headers.get('accept') || 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': request.headers.get('accept-language') || 'zh-CN,zh;q=0.9,en;q=0.8',
      },
      redirect: 'follow',
    });

    // 4. 处理响应内容，替换链接
    let responseBody = await proxyResponse.text();
    // 把页面里的GitHub链接替换成你的/gh/路径
    responseBody = responseBody.replaceAll('https://github.com', `https://${YOUR_DOMAIN}/gh`);
    // 替换RAW文件链接，支持直接查看raw内容
    responseBody = responseBody.replaceAll('https://raw.githubusercontent.com', `https://${YOUR_DOMAIN}/gh/raw`);

    // 5. 返回给浏览器
    return new Response(responseBody, {
      status: proxyResponse.status,
      statusText: proxyResponse.statusText,
      headers: {
        'Content-Type': proxyResponse.headers.get('content-type') || 'text/html; charset=utf-8',
        'Cache-Control': 'public, max-age=1800',
      },
    });
  } catch (error) {
    // 出错时返回500，打印错误信息
    return new Response(`代理出错: ${(error as Error).message}`, {
      status: 500,
    });
  }
};

// 支持所有请求方法
export const POST: APIRoute = GET;
export const PUT: APIRoute = GET;
export const DELETE: APIRoute = GET;
export const PATCH: APIRoute = GET;