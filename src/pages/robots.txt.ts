import type { APIRoute } from "astro";

const robotsTxt = `
# robots.txt - LegspCpd Blog
# https://blog.legspcpd.top

# 允许所有爬虫抓取
User-agent: *

# 屏蔽无需索引的路径
Disallow: /_astro/
Disallow: /api/
Disallow: /og/
Disallow: /gh/
Disallow: /ftp/
Disallow: /search/
Disallow: /yandex_

# 允许特定爬虫更频繁地抓取
User-agent: Googlebot
Crawl-delay: 1

User-agent: Bingbot
Crawl-delay: 1

User-agent: Baiduspider
Crawl-delay: 2

# 禁止抓取特定文件类型（节省爬虫带宽）
Disallow: /*.pdf$
Disallow: /*.zip$
Disallow: /*.gz$

# Sitemap
Sitemap: ${new URL("sitemap-index.xml", import.meta.env.SITE).href}
`.trim();

export const GET: APIRoute = () => {
	return new Response(robotsTxt, {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
		},
	});
};
