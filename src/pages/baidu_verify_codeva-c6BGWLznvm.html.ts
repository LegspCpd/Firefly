import type { APIRoute } from "astro";

// 百度搜索资源平台验证文件
// 必须通过 .html 后缀访问才能通过验证
export const prerender = true;

export const GET: APIRoute = () => {
	return new Response("6e88638317ee7601beb7322f583b149d", {
		headers: {
			"Content-Type": "text/plain; charset=utf-8",
		},
	});
};
