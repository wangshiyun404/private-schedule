#!/usr/bin/env bash
# 取日程数据：优先用本仓库的 CALENDARS_JSON Secret 直接读 iCloud；未配置时临时从公开站拉取（过渡方案）
set -euo pipefail
if [ -n "${CALENDARS_JSON:-}" ]; then
  node scripts/build.js
else
  echo "CALENDARS_JSON 未配置，过渡：从公开站读取 schedule.json"
  mkdir -p public/data
  curl -fsS "https://wangshiyun404.github.io/schedule/data/schedule.json?t=$(date +%s)" -o public/data/schedule.json
fi
node -e "const d=require('./public/data/schedule.json');console.log('events='+d.events.length)"
