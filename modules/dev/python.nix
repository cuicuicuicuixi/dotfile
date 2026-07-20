# Python 环境入口（uv）
# =======================
# 全局安装 uv 作为 Python 包管理器。Python 运行时本身由各项目的
# flake.nix devShell 按需提供（3.12），项目依赖由 uv + pyproject.toml 管理。
#
# 新项目创建方式：
#   nix flake init -t "$HOME/.config/nix#python"    # 普通 Python
#   nix flake init -t "$HOME/.config/nix#python-rocm"  # ROCm Python

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    uv
  ];
}
