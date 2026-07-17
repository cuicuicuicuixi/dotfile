#!/usr/bin/env bash
# ==========================================================
# Nix 配置一键安装（从零开始，无需 Nix 和 Just）
# ==========================================================
# 用法: bash scripts/bootstrap.sh
set -Eeuo pipefail

FLAKE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NIX_INSTALLER_URL="${NIX_INSTALLER_URL:-https://nixos.org/nix/install}"
NIX_INSTALLER_SHA256="${NIX_INSTALLER_SHA256:-}"
export NIX_LOCAL_CONFIG="${NIX_LOCAL_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/nix-local/local.nix}"
INSTALLER_FILE=""

cleanup() {
  if [ -n "$INSTALLER_FILE" ]; then
    rm -f "$INSTALLER_FILE"
  fi
}
trap cleanup EXIT

file_sha256() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  else
    shasum -a 256 "$1" | awk '{print $1}'
  fi
}

echo "================================================"
echo "  Nix 配置安装"
echo "================================================"
echo ""

# ---- 1. 安装 Nix ----
if command -v nix &>/dev/null; then
  echo "==> Nix 已安装: $(nix --version)"
else
  echo "==> 未检测到 Nix，从以下地址下载安装器："
  echo "    $NIX_INSTALLER_URL"
  INSTALLER_FILE=$(mktemp "${TMPDIR:-/tmp}/nix-install.XXXXXX")
  curl --fail --show-error --location --proto '=https' --tlsv1.2 \
    --output "$INSTALLER_FILE" "$NIX_INSTALLER_URL"
  ACTUAL_SHA256=$(file_sha256 "$INSTALLER_FILE")

  if [ -n "$NIX_INSTALLER_SHA256" ]; then
    if [ "$ACTUAL_SHA256" != "$NIX_INSTALLER_SHA256" ]; then
      echo "错误：Nix 安装器 SHA256 校验失败" >&2
      echo "期望: $NIX_INSTALLER_SHA256" >&2
      echo "实际: $ACTUAL_SHA256" >&2
      exit 1
    fi
    echo "==> Nix 安装器 SHA256 校验通过"
  else
    echo "警告：未提供 NIX_INSTALLER_SHA256，下载文件 SHA256 为："
    echo "  $ACTUAL_SHA256"
    read -r -p "确认执行该安装器？输入 INSTALL 继续: " CONFIRM
    if [ "$CONFIRM" != "INSTALL" ]; then
      echo "已取消安装。可设置 NIX_INSTALLER_SHA256 后重新运行。" >&2
      exit 1
    fi
  fi

  sh "$INSTALLER_FILE" --daemon
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  fi
  echo "==> Nix 安装完成"
fi

# ---- 2. 生成仓库外的本机私有配置 ----
if [ ! -f "$NIX_LOCAL_CONFIG" ]; then
  NIX_LOCAL_CONFIG="$NIX_LOCAL_CONFIG" bash "$FLAKE_DIR/scripts/config.sh"
fi

# ---- 3. 首次构建 ----
echo ""
echo "==> 开始首次构建..."
export FLAKE_DIR
bash "$FLAKE_DIR/scripts/switch.sh"
