#!/usr/bin/env bash
set -e

echo "========================================"
echo "  Nix 配置安装脚本"
echo "========================================"
echo ""

REPO_DIR="${1:-$HOME/.config/nix}"

# ---- 1. 安装 Nix ----
if ! command -v nix &>/dev/null; then
  echo "==> 未检测到 Nix，正在安装..."
  sh <(curl -L https://nixos.org/nix/install) --daemon
  # 使 nix 在当前 shell 可用（新 shell 无需此步骤）
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
  echo "==> Nix 安装完成"
else
  echo "==> Nix 已安装: $(nix --version)"
fi

# ---- 2. 检测系统类型 ----
case "$(uname -s)" in
  Darwin)
    SYSTEM="macOS"
    REBUILD_CMD="sudo darwin-rebuild switch --flake $REPO_DIR#MacBook-Pro --impure"
    ;;
  Linux)
    if [ -f /etc/NIXOS ] || grep -q NixOS /etc/os-release 2>/dev/null; then
      SYSTEM="NixOS"
      ARCH=$(uname -m)
      [ "$ARCH" = "x86_64" ] && HOST="nixos-x86" || HOST="nixos-arm"
      REBUILD_CMD="sudo nixos-rebuild switch --flake $REPO_DIR#$HOST --impure"
    else
      SYSTEM="Linux (非 NixOS)"
      ARCH=$(uname -m)
      USER_NAME=$(whoami)
      [ "$ARCH" = "x86_64" ] && HOST="${USER_NAME}@linux-x86" || HOST="${USER_NAME}@linux-arm"
      REBUILD_CMD="home-manager switch --flake $REPO_DIR#$HOST --impure"
    fi
    ;;
  *)
    echo "不支持的系统: $(uname -s)"
    exit 1
    ;;
esac
echo "==> 系统: $SYSTEM"

# ---- 3. 创建 local.nix ----
LOCAL_NIX="$REPO_DIR/modules/home/local.nix"
if [ ! -f "$LOCAL_NIX" ]; then
  echo ""
  echo "==> 配置本地信息 ---"
  read -p "  Git 用户名: " GIT_NAME
  read -p "  Git 邮箱: " GIT_EMAIL
  read -p "  主用户名 [$USER]: " PRIMARY_USER
  PRIMARY_USER="${PRIMARY_USER:-$USER}"

  cat > "$LOCAL_NIX" << EOF
# 本地个人信息（gitignored，不上传到 GitHub）
{
  gitUserName = "$GIT_NAME";
  gitUserEmail = "$GIT_EMAIL";
  primaryUser = "$PRIMARY_USER";
}
EOF
  echo "==> local.nix 已创建"
else
  echo "==> local.nix 已存在，跳过"
fi

# ---- 4. 首次构建 ----
echo ""
echo "==> 开始首次构建..."
cd "$REPO_DIR"
if $REBUILD_CMD; then
  echo ""
  echo "========================================"
  echo "  安装完成！"
  echo "  后续更新执行: ./update_nix.sh"
  echo "========================================"
else
  echo ""
  echo "构建失败，请检查错误信息并修复后重试。"
  echo "手动构建命令: $REBUILD_CMD"
  exit 1
fi
