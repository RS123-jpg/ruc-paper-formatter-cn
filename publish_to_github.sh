#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "用法: bash publish_to_github.sh https://github.com/<用户名>/ruc-paper-formatter-cn.git [branch]" >&2
  exit 1
fi

REPO_URL="$1"
BRANCH="${2:-main}"

if [ ! -f SKILL.md ]; then
  echo "请在仓库根目录运行；当前目录未找到 SKILL.md。" >&2
  exit 1
fi

command -v git >/dev/null 2>&1 || { echo "未检测到 Git。" >&2; exit 1; }

if [ ! -d .git ]; then
  git init
fi

git add .
if [ -n "$(git status --porcelain)" ]; then
  git commit -m "feat: publish cross-ai paper formatter skill"
fi

git branch -M "$BRANCH"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REPO_URL"
else
  git remote add origin "$REPO_URL"
fi

git push -u origin "$BRANCH"
echo "已推送到 $REPO_URL"
