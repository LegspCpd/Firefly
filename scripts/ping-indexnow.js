/**
 * IndexNow 自动提交脚本
 *
 * 构建完成后自动通知 Bing 索引更新。
 * 在 package.json 的 build 脚本中调用：
 *   "build": "astro build && node scripts/ping-indexnow.js"
 *
 * 使用方法：
 *   node scripts/ping-indexnow.js [sitemap-url]
 *
 * 默认使用 siteConfig 中的站点 URL 拼接 sitemap 地址。
 * 也可以手动指定 sitemap URL：
 *   node scripts/ping-indexnow.js https://blog.legspcpd.top/sitemap-index.xml
 */

const BING_INDEXNOW_URL = "https://www.bing.com/indexnow";

async function main() {
	const sitemapUrl =
		process.argv[2] || "https://blog.legspcpd.top/sitemap-index.xml";

	// 从 siteConfig 或环境变量读取 IndexNow key
	const indexnowKey = process.env.INDEXNOW_KEY || "";

	if (!indexnowKey) {
		console.log(
			"[IndexNow] ⚠️  INDEXNOW_KEY 环境变量未设置，跳过 IndexNow 推送。",
		);
		console.log(
			"[IndexNow] 💡 设置 INDEXNOW_KEY 环境变量以启用自动推送。",
		);
		process.exit(0);
	}

	console.log(`[IndexNow] 🔔 正在从 sitemap 读取 URL: ${sitemapUrl}`);

	try {
		// 获取 sitemap 内容
		const response = await fetch(sitemapUrl);
		if (!response.ok) {
			throw new Error(`HTTP ${response.status}: ${response.statusText}`);
		}
		const xml = await response.text();

		// 解析 sitemap 中的所有 URL
		const urlRegex = /<loc>([^<]+)<\/loc>/g;
		let match;
		const urls = [];
		while ((match = urlRegex.exec(xml)) !== null) {
			urls.push(match[1]);
		}

		if (urls.length === 0) {
			console.log("[IndexNow] ⚠️  Sitemap 中未找到 URL");
			process.exit(0);
		}

		console.log(`[IndexNow] 📄 找到 ${urls.length} 个 URL，正在提交到 Bing...`);

		// 批量提交（每次最多 10 个）
		const batchSize = 10;
		let submitted = 0;
		for (let i = 0; i < urls.length; i += batchSize) {
			const batch = urls.slice(i, i + batchSize);
			for (const url of batch) {
				try {
					const indexNowUrl = new URL(BING_INDEXNOW_URL);
					indexNowUrl.searchParams.set("url", url);
					indexNowUrl.searchParams.set("key", indexnowKey);
					const res = await fetch(indexNowUrl.toString());
					if (res.ok) {
						submitted++;
					} else {
						console.warn(
							`[IndexNow] ⚠️  提交失败 (${res.status}): ${url}`,
						);
					}
				} catch (err) {
					console.warn(`[IndexNow] ⚠️  提交出错: ${url}`, err.message);
				}
			}
		}

		console.log(
			`[IndexNow] ✅ 成功提交 ${submitted}/${urls.length} 个 URL 到 Bing IndexNow`,
		);
	} catch (error) {
		console.error("[IndexNow] ❌ 提交失败:", error.message);
		process.exit(1);
	}
}

main();
