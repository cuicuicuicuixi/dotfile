# 通用开发与构建工具（跨平台）
# ==============================
# 从 modules/home/packages.nix 中拆分出来，集中管理开发相关的 CLI 工具、
# 语言运行时、构建系统和 Nix 工具。

{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    # ---- 命令运行器 ----
    just # Make 替代，仓库主入口

    # ---- Node.js 版本管理 ----
    fnm

    # ---- Rust 工具链 ----
    rustc
    cargo

    # ---- C/C++ 构建工具 ----
    cmake
    pkgconf

    # ---- Shell 脚本检查 ----
    shellcheck

    # ---- Nix 工具 ----
    nixfmt # Nix 代码格式化
    statix # Nix 代码 lint

    # ---- AI ----
    claude-code
  ];
}
