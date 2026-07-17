#!/usr/bin/env bash
# Nix Flake 系统重建（自动检测平台）
set -Eeuo pipefail

FLAKE_DIR="${FLAKE_DIR:-$HOME/.config/nix}"
CONNECT_TIMEOUT="${CONNECT_TIMEOUT:-360}"
USE_MIRROR="${USE_MIRROR:-false}"
export NIX_LOCAL_CONFIG="${NIX_LOCAL_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/nix-local/local.nix}"

if [ ! -r "$NIX_LOCAL_CONFIG" ]; then
  echo "错误：缺少本机私有配置 $NIX_LOCAL_CONFIG" >&2
  echo "请先运行: bash $FLAKE_DIR/scripts/config.sh" >&2
  exit 1
fi

PRIMARY_USER=$(nix-instantiate --eval --strict --raw --expr \
  'let path = builtins.getEnv "NIX_LOCAL_CONFIG"; in (import path).primaryUser')
HOST_NAME=$(nix-instantiate --eval --strict --raw --expr \
  'let path = builtins.getEnv "NIX_LOCAL_CONFIG"; config = import path; in config.hostName or ""')
CURRENT_USER=$(id -un)
DETECTED_HOST=$(hostname -s)

if [ -z "${HOST_NAME}" ]; then
  echo "错误：本机配置缺少 hostName，请重新运行 scripts/config.sh。" >&2
  exit 1
fi

if [ "$CURRENT_USER" != "$PRIMARY_USER" ]; then
  echo "错误：当前用户为 $CURRENT_USER，但本机配置的 primaryUser 为 $PRIMARY_USER" >&2
  echo "请使用目标用户运行，或先执行 scripts/config.sh 修正配置。" >&2
  exit 1
fi

if [ "$DETECTED_HOST" != "$HOST_NAME" ]; then
  echo "错误：当前主机名为 ${DETECTED_HOST}，但本机配置记录的是 ${HOST_NAME}" >&2
  echo "主机名变更后请重新运行 scripts/config.sh。" >&2
  exit 1
fi

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
    echo "==> macOS: darwin-rebuild ($HOST_NAME)"
    sudo env NIX_LOCAL_CONFIG="$NIX_LOCAL_CONFIG" \
      darwin-rebuild switch --flake "$FLAKE_DIR#$HOST_NAME" --impure "${EXTRA_ARGS[@]}"
    ;;
  Linux)
    if [ -f /etc/NIXOS ] || grep -q NixOS /etc/os-release 2>/dev/null; then
      case "$ARCH" in
        x86_64) NIXOS_PROFILE="nixos-x86" ;;
        aarch64|arm64) NIXOS_PROFILE="nixos-arm" ;;
        *)
          echo "不支持的 NixOS 架构: $ARCH" >&2
          exit 1
          ;;
      esac
      if [ "$(tail -n 1 "$FLAKE_DIR/hosts/$NIXOS_PROFILE/enabled.nix")" != "true" ]; then
        echo "错误：NixOS 配置模板 $NIXOS_PROFILE 尚未启用。" >&2
        echo "请先生成并检查 hosts/$NIXOS_PROFILE/hardware-configuration.nix，" >&2
        echo "再将 hosts/$NIXOS_PROFILE/enabled.nix 的最后一行改为 true。" >&2
        exit 1
      fi
      echo "==> NixOS: nixos-rebuild ($HOST_NAME, profile=$NIXOS_PROFILE)"
      sudo env NIX_LOCAL_CONFIG="$NIX_LOCAL_CONFIG" \
        nixos-rebuild switch --flake "$FLAKE_DIR#$HOST_NAME" --impure "${EXTRA_ARGS[@]}"
    else
      HOST="$PRIMARY_USER@$HOST_NAME"
      if command -v home-manager >/dev/null 2>&1; then
        echo "==> Linux: home-manager ($HOST)"
        home-manager switch --flake "$FLAKE_DIR#$HOST" --impure "${EXTRA_ARGS[@]}"
      else
        echo "==> Linux: 首次运行，通过 nix run home-manager ($HOST)"
        nix --extra-experimental-features 'nix-command flakes' run home-manager/master -- switch --flake "$FLAKE_DIR#$HOST" --impure "${EXTRA_ARGS[@]}" --extra-experimental-features 'nix-command flakes'
      fi
    fi
    ;;
  *)
    echo "不支持的系统: $OS"
    exit 1
    ;;
esac
