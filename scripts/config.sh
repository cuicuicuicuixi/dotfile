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

detect_login_shell() {
  local user="$1"
  local login_shell=""

  case "$(uname -s)" in
    Linux)
      if command -v getent >/dev/null 2>&1; then
        login_shell=$(getent passwd "$user" 2>/dev/null | awk -F: '{print $7}')
      elif [ -r /etc/passwd ]; then
        login_shell=$(awk -F: -v user="$user" '$1 == user { print $7; exit }' /etc/passwd)
      fi
      ;;
    Darwin)
      # macOS 配置固定使用 Zsh，不跟随账户中的其他 Shell。
      login_shell="/bin/zsh"
      ;;
  esac

  if [ -z "$login_shell" ] && [ "$user" = "$(id -un)" ]; then
    login_shell="${SHELL:-}"
  fi

  case "${login_shell##*/}" in
    bash) printf 'bash' ;;
    zsh) printf 'zsh' ;;
    *) printf 'zsh' ;;
  esac
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
if [ -n "$PROXY_PORT" ]; then
  read -r -p "  HTTP 代理地址（IPv4/主机名）[127.0.0.1]: " PROXY_HOST
  PROXY_HOST="${PROXY_HOST:-127.0.0.1}"
else
  PROXY_HOST="127.0.0.1"
fi

if [[ ! "$PRIMARY_USER" =~ ^[a-zA-Z_][a-zA-Z0-9._-]*$ ]]; then
  echo "错误：主用户名格式无效" >&2
  exit 2
fi

USER_SHELL=$(detect_login_shell "$PRIMARY_USER")
echo "  使用登录 Shell: ${USER_SHELL}（无法识别时默认 zsh）"

if [[ ! "$HOST_NAME" =~ ^[a-zA-Z0-9][a-zA-Z0-9._-]*$ ]]; then
  echo "错误：自动检测到的主机名格式无效: $HOST_NAME" >&2
  echo "可通过 NIX_HOSTNAME 显式指定短主机名。" >&2
  exit 2
fi

if [ -n "$PROXY_PORT" ]; then
  if [[ ! "$PROXY_PORT" =~ ^[0-9]+$ ]] || ((PROXY_PORT < 1 || PROXY_PORT > 65535)); then
    echo "错误：代理端口必须是 1-65535 之间的整数" >&2
    # exit 2
  fi
  if [[ "$PROXY_HOST" =~ ^[0-9.]+$ ]]; then
    if [[ ! "$PROXY_HOST" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
      echo "错误：代理地址必须是有效的 IPv4 地址或主机名" >&2
      # exit 2
    fi
    IFS=. read -r -a PROXY_OCTETS <<< "$PROXY_HOST"
    for octet in "${PROXY_OCTETS[@]}"; do
      if ((10#$octet > 255)); then
        echo "错误：代理地址必须是有效的 IPv4 地址或主机名" >&2
        # exit 2
      fi
    done
  elif [ "${#PROXY_HOST}" -gt 253 ] || [[ ! "$PROXY_HOST" =~ ^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$ ]]; then
    echo "错误：代理地址必须是有效的 IPv4 地址或主机名" >&2
    # exit 2
  fi
fi

GIT_NAME=$(escape_nix_string "$GIT_NAME")
GIT_EMAIL=$(escape_nix_string "$GIT_EMAIL")
PRIMARY_USER=$(escape_nix_string "$PRIMARY_USER")
HOST_NAME=$(escape_nix_string "$HOST_NAME")
PROXY_HOST=$(escape_nix_string "$PROXY_HOST")

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
  shell = "$USER_SHELL";
  proxyHost = "$PROXY_HOST";
  proxyPort = ${PROXY_PORT:-null};
}
NIXEOF
chmod 600 "$LOCAL_NIX"

echo ""
echo "==> 配置已写入 $LOCAL_NIX"
