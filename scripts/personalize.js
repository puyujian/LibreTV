#!/usr/bin/env node

/**
 * 💖 彭彭丹专属影院个性化脚本
 * 此脚本将LibreTV个性化为彭彭丹的专属影院
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 个性化配置
const config = {
  siteName: "彭彭丹的专属影院",
  siteDescription: "💕 彭彭丹的专属私人影院，为你精心打造的观影天堂 💕",
  siteSlogan: "💖 专属于你的浪漫观影时光 💖",
  authorName: "彭彭丹的迪迦",
  shortName: "💖 彭彭丹专属 💖",
  packageName: "pengpengdan-cinema"
};

console.log("🎬✨ 开始为彭彭丹定制专属影院...");

// 创建备份目录
const backupDir = path.join(__dirname, '..', 'backups');
if (!fs.existsSync(backupDir)) {
  fs.mkdirSync(backupDir, { recursive: true });
}

const timestamp = new Date().toISOString().replace(/[:.]/g, '-');

/**
 * 备份并替换文件内容
 */
function personalizeFile(filePath, replacements) {
  const fullPath = path.join(__dirname, '..', filePath);
  
  if (!fs.existsSync(fullPath)) {
    console.log(`⚠️  文件不存在: ${filePath}`);
    return;
  }

  console.log(`  💝 个性化 ${filePath}...`);
  
  // 备份原文件
  const backupPath = path.join(backupDir, `${path.basename(filePath)}.${timestamp}`);
  fs.copyFileSync(fullPath, backupPath);
  
  // 读取文件内容
  let content = fs.readFileSync(fullPath, 'utf8');
  
  // 执行替换
  replacements.forEach(({ from, to, flags = 'g' }) => {
    const regex = new RegExp(from, flags);
    content = content.replace(regex, to);
  });
  
  // 写回文件
  fs.writeFileSync(fullPath, content, 'utf8');
}

/**
 * 个性化JSON文件
 */
function personalizeJsonFile(filePath, updates) {
  const fullPath = path.join(__dirname, '..', filePath);
  
  if (!fs.existsSync(fullPath)) {
    console.log(`⚠️  文件不存在: ${filePath}`);
    return;
  }

  console.log(`  📦 个性化 ${filePath}...`);
  
  // 备份原文件
  const backupPath = path.join(backupDir, `${path.basename(filePath)}.${timestamp}`);
  fs.copyFileSync(fullPath, backupPath);
  
  // 读取并更新JSON
  const json = JSON.parse(fs.readFileSync(fullPath, 'utf8'));
  Object.assign(json, updates);
  
  // 写回文件
  fs.writeFileSync(fullPath, JSON.stringify(json, null, 2), 'utf8');
}

// 1. 个性化 README.md
personalizeFile('README.md', [
  { from: '^# LibreTV - 免费在线视频搜索与观看平台', to: `# ${config.siteName}`, flags: 'm' },
  { from: 'LibreTV 是一个轻量级、免费的在线视频搜索与观看平台', to: `${config.siteName} 是专为彭彭丹打造的私人影院平台` },
  { from: '自由观影，畅享精彩', to: config.siteSlogan },
  { from: '© 2025 LibreTV', to: `© 2025 ${config.siteName}` },
  { from: '\\*\\*项目门户\\*\\*：.*', to: `**💖 彭彭丹的专属影院门户 💖**` }
]);

// 2. 个性化 package.json
personalizeJsonFile('package.json', {
  name: config.packageName,
  description: config.siteDescription,
  author: config.authorName
});

// 3. 个性化 index.html
personalizeFile('index.html', [
  { from: '<title>LibreTV - 免费在线视频搜索与观看平台</title>', to: `<title>${config.siteName}</title>` },
  { from: 'content="LibreTV是一个免费的在线视频搜索平台[^"]*"', to: `content="${config.siteDescription}"` },
  { from: 'content="LibreTV Team"', to: `content="${config.authorName}"` },
  { from: 'class="text-xl font-bold gradient-text">LibreTV<', to: `class="text-xl font-bold gradient-text">${config.shortName}<` }
]);

// 4. 个性化 about.html
personalizeFile('about.html', [
  { from: '<title>关于我们 - LibreTV</title>', to: `<title>关于我们 - ${config.siteName}</title>` },
  { from: 'class="text-xl font-bold gradient-text">LibreTV<', to: `class="text-xl font-bold gradient-text">${config.shortName}<` },
  { from: '<h2 class="text-xl font-semibold">关于LibreTV</h2>', to: `<h2 class="text-xl font-semibold">关于${config.siteName}</h2>` },
  { from: 'LibreTV 是一个免费的在线视频搜索平台', to: `${config.siteName} 是专为彭彭丹打造的私人影院` },
  { from: '© 2025 LibreTV', to: `© 2025 ${config.siteName}` },
  { from: 'class="gradient-text font-bold">LibreTV<', to: `class="gradient-text font-bold">${config.shortName}<` }
]);

// 5. 个性化 player.html
personalizeFile('player.html', [
  { from: '<title>LibreTV 播放器</title>', to: `<title>${config.siteName} 播放器</title>` },
  { from: 'class="text-xl font-bold gradient-text logo-text">LibreTV<', to: `class="text-xl font-bold gradient-text logo-text">${config.shortName}<` }
]);

// 6. 个性化 watch.html
personalizeFile('watch.html', [
  { from: 'class="logo-text">LibreTV<', to: `class="logo-text">${config.shortName}<` }
]);

// 7. 个性化 manifest.json
personalizeJsonFile('manifest.json', {
  name: config.siteName,
  short_name: "彭彭丹专属",
  description: config.siteDescription
});

console.log("✨ 个性化完成！");
console.log("💖 所有文件已成功个性化为彭彭丹的专属影院");
console.log(`📁 原始文件备份保存在 ${backupDir} 目录中`);
console.log("🎉 享受你的专属观影时光吧！");
