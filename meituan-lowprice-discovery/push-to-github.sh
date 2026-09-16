#!/usr/bin/env bash
set -e

# ===== 0. 确保已登录 GitHub（未登录会交互跳转浏览器授权）=====
gh auth status || gh auth login

# ===== 1. （可选）改成你自己的 git 身份 =====
# 取消下面两行注释并改成你的信息，再执行一次提交即可更正作者：
# git config user.name  "你的名字"
# git config user.email "you@example.com"

# ===== 2. 统一分支名为 main（GitHub 默认）=====
git branch -M main

# ===== 3. 创建私有仓库并推送 =====
REPO="meituan-lowprice-discovery"   # 想换仓库名改这里
OWNER=$(gh api user --jq .login)

if gh repo view "$OWNER/$REPO" >/dev/null 2>&1; then
  echo "仓库 $OWNER/$REPO 已存在，直接绑定并推送…"
  git remote add origin "git@github.com:$OWNER/$REPO.git" 2>/dev/null || \
    git remote set-url origin "git@github.com:$OWNER/$REPO.git"
  git push -u origin main
else
  echo "创建私有仓库 $OWNER/$REPO 并推送…"
  gh repo create "$REPO" --private --source . --remote origin --push
fi

echo "✅ 完成：https://github.com/$OWNER/$REPO"
