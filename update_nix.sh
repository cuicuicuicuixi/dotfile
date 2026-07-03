#!/usr/bin/env bash
set -e

FLAKE_DIR="$HOME/.config/nix"
CONNECT_TIMEOUT=360
USE_MIRROR=false

# 国内镜像源（清华 + 上交 + 中科大 + 官方兜底）
MIRROR_SUBSTITUTERS="https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirror.sjtu.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org"

usage() {
  echo "用法: $0 [-m|--mirror]"
  echo "  -m, --mirror  使用国内镜像源加速下载"
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--mirror) USE_MIRROR=true; shift ;;
    -h|--help) usage ;;
    *) echo "未知选项: $1"; usage ;;
  esac
done

# 构建公共参数
EXTRA_ARGS=(--option connect-timeout "$CONNECT_TIMEOUT")
if $USE_MIRROR; then
  EXTRA_ARGS+=(--option substituters "$MIRROR_SUBSTITUTERS")
fi

# 检测系统类型
case "$(uname -s)" in
  Darwin)
    echo "==> macOS 检测到，使用 darwin-rebuild"
    sudo darwin-rebuild switch --flake "$FLAKE_DIR#MacBook-Pro" --impure "${EXTRA_ARGS[@]}"
    ;;
  Linux)
    ARCH=$(uname -m)
    case "$ARCH" in
      x86_64|aarch64) ;;
      *)
        echo "不支持的架构: $ARCH"
        exit 1
        ;;
    esac

    # 检测是否为 NixOS
    if [ -f /etc/NIXOS ] || grep -q NixOS /etc/os-release 2>/dev/null; then
      [ "$ARCH" = "x86_64" ] && HOST="nixos-x86" || HOST="nixos-arm"
      echo "==> NixOS ($ARCH) 检测到，使用 nixos-rebuild"
      sudo nixos-rebuild switch --flake "$FLAKE_DIR#$HOST" --impure "${EXTRA_ARGS[@]}"
    else
      # 非 NixOS Linux，使用独立 home-manager
      [ "$ARCH" = "x86_64" ] && HOST="${USER}@linux-x86" || HOST="${USER}@linux-arm"
      echo "==> Linux 非 NixOS ($ARCH) 检测到，使用 home-manager"
      home-manager switch --flake "$FLAKE_DIR#$HOST" --impure "${EXTRA_ARGS[@]}"
    fi
    ;;
  *)
    echo "不支持的系统: $(uname -s)"
    exit 1
    ;;
esac
