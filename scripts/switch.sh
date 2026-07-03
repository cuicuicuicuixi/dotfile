#!/usr/bin/env bash
# Nix Flake 系统重建（自动检测平台）
set -e

FLAKE_DIR="${FLAKE_DIR:-$HOME/.config/nix}"
CONNECT_TIMEOUT="${CONNECT_TIMEOUT:-360}"
USE_MIRROR="${USE_MIRROR:-false}"

# 国内镜像源
MIRROR_SUBSTITUTERS="https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org"

ARCH="$(uname -m)"
OS="$(uname -s)"

echo "==> 系统: $OS ($ARCH)"

# 构建公共参数
EXTRA_ARGS=(--option connect-timeout "$CONNECT_TIMEOUT")
if [ "$USE_MIRROR" = "true" ]; then
  EXTRA_ARGS+=(--option substituters "$MIRROR_SUBSTITUTERS")
fi

case "$OS" in
  Darwin)
    echo "==> macOS: darwin-rebuild"
    sudo darwin-rebuild switch --flake "$FLAKE_DIR#MacBook-Pro" --impure "${EXTRA_ARGS[@]}"
    ;;
  Linux)
    if [ -f /etc/NIXOS ] || grep -q NixOS /etc/os-release 2>/dev/null; then
      HOST=$(if [ "$ARCH" = "x86_64" ]; then echo "nixos-x86"; else echo "nixos-arm"; fi)
      echo "==> NixOS: nixos-rebuild ($HOST)"
      sudo nixos-rebuild switch --flake "$FLAKE_DIR#$HOST" --impure "${EXTRA_ARGS[@]}"
    else
      HOST="$(whoami)@$(if [ "$ARCH" = "x86_64" ]; then echo "linux-x86"; else echo "linux-arm"; fi)"
      echo "==> Linux: home-manager ($HOST)"
      home-manager switch --flake "$FLAKE_DIR#$HOST" --impure "${EXTRA_ARGS[@]}"
    fi
    ;;
  *)
    echo "不支持的系统: $OS"
    exit 1
    ;;
esac
