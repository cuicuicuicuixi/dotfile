# NixOS 基础系统设置
# ====================
# 最小可用 NixOS 配置，包含 NixOS 强制要求的选项：
#   - boot.loader        — 系统引导
#   - fileSystems."/"    — 根分区挂载点
#   - programs.zsh       — zsh 启用（user shell 的前置条件）
#   - system.stateVersion
#
# 注意：fileSystems 和 boot.loader 配置是占位默认值，
# 不同机器的磁盘布局不同，安装时需要按实际情况调整。

{ ... }:
{
  # flakes + unfree 白名单已由 flake.nix 的 baseNixConfig 统一设置
  # 系统 locale
  i18n.defaultLocale = "en_US.UTF-8";

  # 启用 zsh — NixOS 要求 user shell 对应的 program 必须 enable
  programs.zsh.enable = true;

  # ---- 根文件系统（安装时按实际磁盘修改） ----
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  # ---- 引导加载器（UEFI systemd-boot） ----
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NixOS 要求设置状态版本
  system.stateVersion = "25.05";
}
