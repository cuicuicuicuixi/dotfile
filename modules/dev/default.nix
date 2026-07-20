# 跨平台开发环境配置入口
# ==========================
# 集中管理开发工具、语言运行时、direnv 集成和 Python 环境。
# 所有子模块独立，可被 home-manager 在 macOS / NixOS / 其他 Linux 上复用。

{
  imports = [
    ./direnv.nix
    ./packages.nix
    ./python.nix
  ];
}
