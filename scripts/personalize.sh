#!/bin/bash

# 💖 彭彭丹专属影院个性化脚本
# 此脚本将LibreTV个性化为彭彭丹的专属影院

set -e

echo "🎬✨ 开始为彭彭丹定制专属影院..."

# 定义个性化内容
SITE_NAME="彭彭丹的专属影院"
SITE_DESCRIPTION="💕 彭彭丹的专属私人影院，为你精心打造的观影天堂 💕"
SITE_SLOGAN="💖 专属于你的浪漫观影时光 💖"
AUTHOR_NAME="彭彭丹的专属开发者"
SHORT_NAME="💖 彭彭丹专属 💖"

# 创建备份目录
mkdir -p backups
timestamp=$(date +%Y%m%d_%H%M%S)

echo "📝 开始个性化文件..."

# 1. 个性化 README.md
echo "  💝 个性化 README.md..."
cp README.md "backups/README.md.${timestamp}"
sed -i.bak "1s/.*/# ${SITE_NAME}/" README.md
sed -i.bak "s/LibreTV 是一个轻量级、免费的在线视频搜索与观看平台/${SITE_NAME} 是专为彭彭丹打造的私人影院平台/g" README.md
sed -i.bak "s/自由观影，畅享精彩/${SITE_SLOGAN}/g" README.md
sed -i.bak "s/© 2025 LibreTV/© 2025 ${SITE_NAME}/g" README.md
sed -i.bak "s/项目门户.*libretv\.is-an\.org.*/💖 彭彭丹的专属影院门户 💖/g" README.md

# 2. 个性化 package.json
echo "  📦 个性化 package.json..."
cp package.json "backups/package.json.${timestamp}"
sed -i.bak 's/"name": "libretv"/"name": "pengpengdan-cinema"/g' package.json
sed -i.bak "s/\"description\": \"免费在线视频搜索与观看平台\"/\"description\": \"${SITE_DESCRIPTION}\"/g" package.json
sed -i.bak "s/\"author\": \"bestZwei\"/\"author\": \"${AUTHOR_NAME}\"/g" package.json

# 3. 个性化 index.html
echo "  🏠 个性化 index.html..."
cp index.html "backups/index.html.${timestamp}"
sed -i.bak "s/<title>LibreTV - 免费在线视频搜索与观看平台<\/title>/<title>${SITE_NAME}<\/title>/g" index.html
sed -i.bak "s/content=\"LibreTV是一个免费的在线视频搜索平台[^\"]*\"/content=\"${SITE_DESCRIPTION}\"/g" index.html
sed -i.bak "s/content=\"LibreTV Team\"/content=\"${AUTHOR_NAME}\"/g" index.html
sed -i.bak "s/gradient-text\">LibreTV</gradient-text\">${SHORT_NAME}</g" index.html

# 4. 个性化 about.html
echo "  ℹ️ 个性化 about.html..."
cp about.html "backups/about.html.${timestamp}"
sed -i.bak "s/<title>关于我们 - LibreTV<\/title>/<title>关于我们 - ${SITE_NAME}<\/title>/g" about.html
sed -i.bak "s/gradient-text\">LibreTV</gradient-text\">${SHORT_NAME}</g" about.html
sed -i.bak "s/<h2 class=\"text-xl font-semibold\">关于LibreTV<\/h2>/<h2 class=\"text-xl font-semibold\">关于${SITE_NAME}<\/h2>/g" about.html
sed -i.bak "s/LibreTV 是一个免费的在线视频搜索平台/${SITE_NAME} 是专为彭彭丹打造的私人影院/g" about.html
sed -i.bak "s/© 2025 LibreTV/© 2025 ${SITE_NAME}/g" about.html

# 5. 个性化 player.html
echo "  ▶️ 个性化 player.html..."
cp player.html "backups/player.html.${timestamp}"
sed -i.bak "s/<title>LibreTV 播放器<\/title>/<title>${SITE_NAME} 播放器<\/title>/g" player.html
sed -i.bak "s/gradient-text logo-text\">LibreTV</gradient-text logo-text\">${SHORT_NAME}</g" player.html

# 6. 个性化 watch.html
echo "  ⏯️ 个性化 watch.html..."
cp watch.html "backups/watch.html.${timestamp}"
sed -i.bak "s/logo-text\">LibreTV</logo-text\">${SHORT_NAME}</g" watch.html

# 7. 个性化 manifest.json
echo "  📱 个性化 manifest.json..."
cp manifest.json "backups/manifest.json.${timestamp}"
sed -i.bak "s/\"name\": \"LibreTV\"/\"name\": \"${SITE_NAME}\"/g" manifest.json
sed -i.bak "s/\"short_name\": \"LibreTV\"/\"short_name\": \"彭彭丹专属\"/g" manifest.json
sed -i.bak "s/\"description\": \"免费在线视频搜索与观看平台\"/\"description\": \"${SITE_DESCRIPTION}\"/g" manifest.json

# 清理临时文件
find . -name "*.bak" -delete

echo "✨ 个性化完成！"
echo "💖 所有文件已成功个性化为彭彭丹的专属影院"
echo "📁 原始文件备份保存在 backups/ 目录中"
echo "🎉 享受你的专属观影时光吧！"
