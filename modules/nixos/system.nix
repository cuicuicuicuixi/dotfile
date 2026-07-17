# NixOS 基础系统设置
# ====================
# 跨主机共享的 NixOS 设置。
# 磁盘、文件系统、内核模块和引导配置由 hosts/<hostname>/
# 下的 hardware-configuration.nix 按机器提供。

{ ... }:
{
  # flakes + unfree 白名单已由 flake.nix 的 baseNixConfig 统一设置
  # 系统 locale
  i18n.defaultLocale = "en_US.UTF-8";

  # NixOS 要求登录 Shell 对应的程序显式启用。
  programs.zsh.enable = true;

  # NixOS 要求设置状态版本
  system.stateVersion = "25.05";
}
