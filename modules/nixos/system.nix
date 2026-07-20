# NixOS 基础系统设置
# ====================
# 跨主机共享的 NixOS 设置。
# 磁盘、文件系统、内核模块和引导配置由 hosts/<hostname>/
# 下的 hardware-configuration.nix 按机器提供。

{ localConfig, ... }:
{
  # flakes + unfree 白名单已由 flake.nix 的 baseNixConfig 统一设置
  # 系统 locale
  i18n.defaultLocale = "en_US.UTF-8";

  # 仅在检测到 Zsh 时启用对应的 NixOS 程序支持；Bash 由系统默认提供。
  programs.zsh.enable = (localConfig.shell or "zsh") == "zsh";

  # NixOS 要求设置状态版本
  system.stateVersion = "25.05";
}
