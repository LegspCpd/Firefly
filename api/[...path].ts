export const config = {
  runtime: 'edge',
};

// GitHub目标地址
const TARGET_BASE = 'https://github.com';
// 你的博客域名
const YOUR_DOMAIN = 'blog.legspcpd.indevs.in';

export default async function handler(request: Request) {
  try {
    const url = new URL(request.url);
    // 1. 提取路径：把 /api/ 替换掉
    let path = url.pathname.replace('/api/', '');
    
    // 2. 构建GitHub目标URL
    const targetUrl = new URL(`/${path}`, TARGET_BASE);
    targetUrl.search = url.search;

    // 3. 转发请求
    const res = await fetch(targetUrl.toString(), {
      method: request.method,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        'Accept': request.headers.get('accept') || '*/*',
      },
      body: request.body,
      redirect: 'follow',
    });

    // 4. 处理响应，替换链接
    let body = await res.text();
    body = body.replaceAll('https://github.com', `https://${YOUR_DOMAIN}/gh`);
    body = body.replaceAll('https://raw.githubusercontent.com', `https://${YOUR_DOMAIN}/gh/raw`);

    // 5. 返回
    return new Response(body, {
      status: res.status,
      headers: {
        'Content-Type': res.headers.get('content-type') || 'text/html',
      },
    });
  } catch (e) {
    return new Response('Error: ' + (e as Error).message, { status: 500 });
  }
}