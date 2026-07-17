#!/usr/bin/env bash
set -Eeuo pipefail

LOCAL_NIX="${NIX_LOCAL_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/nix-local/local.nix}"
HOST_NAME="${NIX_HOSTNAME:-$(hostname -s)}"

case "$(uname -s):$(uname -m)" in
  Linux:x86_64) HOME_SYSTEM="x86_64-linux" ;;
  Linux:aarch64|Linux:arm64) HOME_SYSTEM="aarch64-linux" ;;
  Darwin:x86_64) HOME_SYSTEM="x86_64-darwin" ;;
  Darwin:aarch64|Darwin:arm64) HOME_SYSTEM="aarch64-darwin" ;;
  *)
    echo "错误：不支持的系统平台 $(uname -s)/$(uname -m)" >&2
    exit 2
    ;;
esac

escape_nix_string() {
  printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/${/\\${/g'
}

echo "================================================"
echo "  配置本地信息（${LOCAL_NIX}）"
echo "================================================"
echo ""

read -r -p "  Git 用户名: " GIT_NAME
read -r -p "  Git 邮箱: " GIT_EMAIL
read -r -p "  主用户名 [$(whoami)]: " PRIMARY_USER
PRIMARY_USER="${PRIMARY_USER:-$(whoami)}"
read -r -p "  HTTP 代理端口（留空=无代理）: " PROXY_PORT

if [[ ! "$PRIMARY_USER" =~ ^[a-zA-Z_][a-zA-Z0-9._-]*$ ]]; then
  echo "错误：主用户名格式无效" >&2
  exit 2
fi

if [[ ! "$HOST_NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]]; then
  echo "错误：自动检测到的主机名格式无效: $HOST_NAME" >&2
  echo "可通过 NIX_HOSTNAME 显式指定短主机名。" >&2
  exit 2
fi

if [ -n "$PROXY_PORT" ]; then
  if [[ ! "$PROXY_PORT" =~ ^[0-9]+$ ]] || ((PROXY_PORT < 1 || PROXY_PORT > 65535)); then
    echo "错误：代理端口必须是 1-65535 之间的整数" >&2
    exit 2
  fi
  PROXY_LINE="proxyPort = $PROXY_PORT;"
else
  PROXY_LINE="proxyPort = null;"
fi

GIT_NAME=$(escape_nix_string "$GIT_NAME")
GIT_EMAIL=$(escape_nix_string "$GIT_EMAIL")
PRIMARY_USER=$(escape_nix_string "$PRIMARY_USER")
HOST_NAME=$(escape_nix_string "$HOST_NAME")

mkdir -p "$(dirname "$LOCAL_NIX")"
chmod 700 "$(dirname "$LOCAL_NIX")"

cat > "$LOCAL_NIX" <<NIXEOF
# 本机私有配置；不属于 Flake 仓库。
{
  gitUserName = "$GIT_NAME";
  gitUserEmail = "$GIT_EMAIL";
  primaryUser = "$PRIMARY_USER";
  hostName = "$HOST_NAME";
  homeSystem = "$HOME_SYSTEM";
  $PROXY_LINE
}
NIXEOF
chmod 600 "$LOCAL_NIX"

echo ""
echo "==> 配置已写入 $LOCAL_NIX"
