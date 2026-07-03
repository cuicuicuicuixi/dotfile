#!/usr/bin/env bash
set -e

FLAKE_DIR="${1:-$HOME/.config/nix}"
LOCAL_NIX="$FLAKE_DIR/modules/home/local.nix"

echo "================================================"
echo "  配置本地信息（local.nix）"
echo "================================================"
echo ""

read -p "  Git 用户名: " GIT_NAME
read -p "  Git 邮箱: " GIT_EMAIL
read -p "  主用户名 [$(whoami)]: " PRIMARY_USER
PRIMARY_USER="${PRIMARY_USER:-$(whoami)}"

cat > "$LOCAL_NIX" << NIXEOF
# 本地个人信息（不要提交到 git！）
{
  gitUserName = "$GIT_NAME";
  gitUserEmail = "$GIT_EMAIL";
  primaryUser = "$PRIMARY_USER";
}
NIXEOF

echo ""
echo "==> 配置已写入 modules/home/local.nix"
