# 字体安装（跨平台）
# ====================
# 编程字体优先级：MonacoLigaturized（macOS 系统用户字体）→ Nerd Fonts（nixpkgs）
# CJK 字体优先级：macOS → 系统 PingFang/苹方，Linux → Source Han Sans/Serif
# fontconfig 让终端等 app 能发现 Nix store 中的字体。
#
# macOS 系统字体路径通过 configFile 注入，确保苹方、手札体、MonacoLigaturized
# 等系统/用户字体可被 nix 安装的 app 发现。

{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = config.home.homeDirectory;

  # macOS 字体搜索路径
  # - /System/Library/Fonts: SF Mono、Monaco（原版）、PingFang 等
  # - Supplemental: STHeiti 等补充字体
  # - /Library/Fonts: 全局安装字体
  # - ~/Library/Fonts: 用户安装字体（MonacoLigaturized 等）
  darwinFontDirs = lib.optionals isDarwin [
    "/System/Library/Fonts"
    "/System/Library/Fonts/Supplemental"
    "/Library/Fonts"
    "${homeDir}/Library/Fonts"
  ];
in
{
  fonts.fontconfig = {
    enable = true;

    # 跨平台默认字体优先级
    # 列表按优先级排列，fontconfig 会选取第一个可用字体
    defaultFonts = {
      monospace = [
        "MonacoLigaturized"              # 用户自定义 Monaco（Nerd Font + 连体）
        "JetBrainsMono Nerd Font Mono"   # 现代编程字体（nixpkgs）
        "FiraCode Nerd Font Mono"        # 含编程连体（nixpkgs）
        "MesloLG Nerd Font Mono"         # Menlo 衍生，Apple 系（nixpkgs）
        "PingFang SC"                    # 苹方（macOS 系统字体）
        "Source Han Sans SC"             # 思源黑体（Linux CJK）
      ];
      sansSerif = [
        "PingFang SC"
        "Source Han Sans SC"
      ];
      serif = [
        "PingFang SC"
        "Source Han Serif SC"
      ];
    };

    # macOS: 注入系统/用户字体路径
    configFile = lib.mkIf (darwinFontDirs != []) {
      system-font-dirs = {
        enable = true;
        priority = 10;
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            ${builtins.concatStringsSep "\n" (map (dir: "    <dir>${dir}</dir>") darwinFontDirs)}
          </fontconfig>
        '';
      };
    };
  };

  home.packages = with pkgs; [
    # ---- 编程字体（Nerd Fonts，含图标补丁，跨平台） ----
    nerd-fonts.jetbrains-mono   # 现代编程字体
    nerd-fonts.fira-code        # 含编程连体
    nerd-fonts.meslo-lg         # Menlo 衍生，最接近 Monaco 的 nixpkgs 字体
    # ---- CJK 字体（Linux 主力，macOS 作为系统字体补充） ----
    source-han-sans             # 思源黑体
    source-han-serif            # 思源宋体
  ];
}
