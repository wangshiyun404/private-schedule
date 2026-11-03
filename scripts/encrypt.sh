#!/usr/bin/env bash
set -euo pipefail
[ -n "${SITE_PASSWORD:-}" ] || { echo "SITE_PASSWORD 未配置"; exit 1; }
cd public
npx -y staticrypt@3 *.html -d . -p "$SITE_PASSWORD" --short --remember 30 \
  --config ../.staticrypt.json \
  --template-title "王世赟 · 私人日程" \
  --template-instructions "这是私人页面，请输入访问密码。" \
  --template-placeholder "访问密码" --template-button "进入" \
  --template-remember "记住我（30 天）" --template-error "密码不正确" \
  --template-toggle-show "显示密码" --template-toggle-hide "隐藏密码" > /dev/null
# 加密模板加 noindex
for f in *.html; do sed -i 's#<head>#<head><meta name="robots" content="noindex,nofollow">#' "$f"; done
for f in *.html; do grep -q staticrypt-html "$f" || { echo "未加密: $f"; exit 1; }; done
echo encrypted
