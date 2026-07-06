#!/usr/bin/env bash
# ==========================================================
# Nix 配置一键安装（从零开始，无需 Nix 和 Just）
# ==========================================================
# 用法: bash scripts/bootstrap.sh
set -e

FLAKE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "================================================"
echo "  Nix 配置安装"
echo "================================================"
echo ""

# ---- 1. 安装 Nix ----
if command -v nix &>/dev/null; then
  echo "==> Nix 已安装: $(nix --version)"
else
  echo "==> 未检测到 Nix，正在安装..."
  sh <(curl -L https://nixos.org/nix/install) --daemon
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  elif [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  fi
  echo "==> Nix 安装完成"
fi

# ---- 2. 生成本地配置 ----
if [ ! -f "$FLAKE_DIR/modules/home/local.nix" ]; then
  bash "$FLAKE_DIR/scripts/config.sh" "$FLAKE_DIR"
fi

# ---- 3. 首次构建 ----
echo ""
echo "==> 开始首次构建..."
FLAKE_DIR="$FLAKE_DIR" bash "$FLAKE_DIR/scripts/switch.sh"
