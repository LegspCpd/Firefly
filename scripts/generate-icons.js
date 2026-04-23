/**
 * 图标预处理脚本（全量图标集版）
 * 在构建时自动扫描 Svelte 组件中使用的图标，并生成内联 SVG 数据
 * 支持所有 Iconify 图标集，无需单独安装 @iconify-json/* 包
 *
 * 使用方法：node scripts/generate-icons.js
 * 前置依赖：pnpm add @iconify/json
 */

import { readFileSync, writeFileSync, readdirSync, statSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";
import { getIconData, iconToSVG, iconToHTML, replaceIDs } from "@iconify/utils";
// 引入全量图标集数据包
import { icons } from "@iconify/json";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT_DIR = join(__dirname, "..");
const SRC_DIR = join(ROOT_DIR, "src");
const OUTPUT_FILE = join(SRC_DIR, "constants", "icons.ts");

// 【已移除】不再限制图标集，支持所有 Iconify 图标集
// const ICON_SETS = { ... };

// 图标集数据缓存
const iconSetCache = new Map();

/**
 * 递归获取目录下所有文件
 */
function getAllFiles(dir, extensions = [".svelte"]) {
	const files = [];

	function walk(currentDir) {
		const items = readdirSync(currentDir);
		for (const item of items) {
			const fullPath = join(currentDir, item);
			const stat = statSync(fullPath);

			if (stat.isDirectory()) {
				// 跳过 node_modules 和隐藏目录
				if (!item.startsWith(".") && item !== "node_modules") {
					walk(fullPath);
				}
			} else if (extensions.some((ext) => item.endsWith(ext))) {
				files.push(fullPath);
			}
		}
	}

	walk(dir);
	return files;
}

/**
 * 从文件内容中提取图标名称
 */
function extractIconNames(content) {
	const icons = new Set();

	// 匹配各种图标使用模式
	const patterns = [
		// icon="xxx:yyy" 或 icon='xxx:yyy'
		/icon=["']([a-z0-9-]+:[a-z0-9-]+)["']/gi,
		// icon={`xxx:yyy`}
		/icon=\{[`"']([a-z0-9-]+:[a-z0-9-]+)[`"']\}/gi,
		// getIconSvg("xxx:yyy") 或 getIconSvg('xxx:yyy')
		/getIconSvg\(["']([a-z0-9-]+:[a-z0-9-]+)["']\)/gi,
		// hasIcon("xxx:yyy")
		/hasIcon\(["']([a-z0-9-]+:[a-z0-9-]+)["']\)/gi,
	];

	for (const pattern of patterns) {
		let match;
		while ((match = pattern.exec(content)) !== null) {
			icons.add(match[1]);
		}
	}

	return icons;
}

/**
 * 加载图标集数据（从全量数据包加载）
 */
async function loadIconSet(prefix) {
	if (iconSetCache.has(prefix)) {
		return iconSetCache.get(prefix);
	}

	// 直接从 @iconify/json 获取图标集数据
	if (icons[prefix]) {
		iconSetCache.set(prefix, icons[prefix]);
		return icons[prefix];
	}

	console.warn(`⚠️  未知图标集: ${prefix}`);
	return null;
}

/**
 * 获取单个图标的 SVG
 */
async function getIconSvg(iconName) {
	const [prefix, name] = iconName.split(":");
	if (!prefix || !name) {
		console.warn(`⚠️  无效的图标名称: ${iconName}`);
		return null;
	}

	const iconSet = await loadIconSet(prefix);
	if (!iconSet) {
		return null;
	}

	const iconData = getIconData(iconSet, name);
	if (!iconData) {
		console.warn(`⚠️  图标未找到: ${iconName}`);
		return null;
	}

	// 转换为 SVG
	const renderData = iconToSVG(iconData, {
		height: "1em",
		width: "1em",
	});

	let svg = iconToHTML(replaceIDs(renderData.body), renderData.attributes);

	// 确保支持 currentColor
	if (!svg.includes("currentColor")) {
		svg = svg.replace("<svg", '<svg fill="currentColor"');
	}

	return svg;
}

/**
 * 生成 icons.ts 文件
 */
function generateIconsFile(iconsMap) {
	const iconEntries = Array.from(iconsMap.entries())
		.sort(([a], [b]) => a.localeCompare(b))
		.map(([name, svg]) => `\t"${name}":\n\t\t'${svg.replace(/'/g, "\\'")}'`)
		.join(",\n");

	const content = `/**
 * 自动生成的图标数据文件
 * 由 scripts/generate-icons.js 在构建时生成
 * 请勿手动编辑此文件
 */

const iconSvgData: Record<string, string> = {
${iconEntries}
};

/**
 * 根据 iconify 格式的图标名获取内联 SVG HTML
 * @param iconName 图标名称，如 "material-symbols:search"
 * @returns SVG HTML 字符串
 */
export function getIconSvg(iconName: string): string {
	return iconSvgData[iconName] || "";
}

/**
 * 检查图标是否可用
 */
export function hasIcon(iconName: string): boolean {
	return iconName in iconSvgData;
}

/**
 * 获取所有可用图标名称
 */
export function getAvailableIcons(): string[] {
	return Object.keys(iconSvgData);
}

export default iconSvgData;
`;

	return content;
}

/**
 * 主函数
 */
async function main() {
	console.log("🔍 扫描源文件中的图标使用...\n");

	// 获取所有源文件
	const files = getAllFiles(SRC_DIR);
	console.log(`📁 找到 ${files.length} 个源文件\n`);

	// 收集所有使用的图标
	const allIcons = new Set();

	for (const file of files) {
		// 跳过 icons.ts 文件本身
		if (file.endsWith("icons.ts")) continue;

		const content = readFileSync(file, "utf-8");
		const icons = extractIconNames(content);

		for (const icon of icons) {
			allIcons.add(icon);
		}
	}

	console.log(`🎨 发现 ${allIcons.size} 个不同的图标:\n`);

	// 按图标集分组显示
	const iconsBySet = {};
	for (const icon of allIcons) {
		const [prefix] = icon.split(":");
		if (!iconsBySet[prefix]) {
			iconsBySet[prefix] = [];
		}
		iconsBySet[prefix].push(icon);
	}

	for (const [prefix, icons] of Object.entries(iconsBySet)) {
		console.log(`   ${prefix}: ${icons.length} 个图标`);
	}
	console.log("");

	// 获取所有图标的 SVG
	const iconsMap = new Map();
	let successCount = 0;
	let failCount = 0;

	for (const iconName of allIcons) {
		const svg = await getIconSvg(iconName);
		if (svg) {
			iconsMap.set(iconName, svg);
			successCount++;
		} else {
			failCount++;
		}
	}

	console.log(`✅ 成功加载 ${successCount} 个图标`);
	if (failCount > 0) {
		console.log(`❌ 失败 ${failCount} 个图标`);
	}

	// 生成输出文件
	const output = generateIconsFile(iconsMap);
	writeFileSync(OUTPUT_FILE, output, "utf-8");

	console.log(`\n📝 已生成: ${OUTPUT_FILE}`);
	console.log(`📦 文件大小: ${(Buffer.byteLength(output, "utf-8") / 1024).toFixed(2)} KB\n`);
}

main().catch(console.error);