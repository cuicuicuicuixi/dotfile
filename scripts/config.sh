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
read -p "  HTTP 代理端口（留空=无代理）: " PROXY_PORT

if [ -n "$PROXY_PORT" ]; then
  PROXY_LINE="proxyPort = $PROXY_PORT;"
else
  PROXY_LINE="proxyPort = null;"
fi

cat > "$LOCAL_NIX" << NIXEOF
# 本地个人信息
{
  gitUserName = "$GIT_NAME";
  gitUserEmail = "$GIT_EMAIL";
  primaryUser = "$PRIMARY_USER";
  $PROXY_LINE
}
NIXEOF

echo ""
echo "==> 配置已写入 modules/home/local.nix"
