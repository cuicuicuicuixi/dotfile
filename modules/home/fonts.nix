# 字体安装（跨平台）
# ====================
#
# ---- 字体优先级 ----
# 编程（monospace）：MonacoLigaturized → JetBrainsMono → FiraCode → MesloLGS → PingFang SC → Source Han Sans
# 无衬线（sans-serif）：PingFang SC → Source Han Sans SC
# 衬线（serif）：PingFang SC → Source Han Serif SC
#
# ---- fontconfig 做了什么 ----
# fontconfig 是 Linux/跨平台 字体发现和匹配系统。macOS 原生用 CoreText，
# 但很多 nix app（WezTerm、GTK 程序等）通过 fontconfig 找字体。
#
# fontconfig 分三层工作：
# 1. 字体发现（<dir>）：扫描指定目录的所有字体文件，建立字体索引
# 2. 字体匹配（fc-match）：根据 family/spacing/lang 等属性选择最佳字体
# 3. 别名替换（<alias>）：将通用名（monospace/sans-serif/serif）映射到具体字体
#
# 本配置做了三件事：
# a) <dir> 注入 macOS 系统/用户字体路径 → nix app 能发现苹方、MonacoLigaturized 等
# b) <alias> 设定默认字体优先级 → fc-match monospace 首选 MonacoLigaturized
# c) 额外 sans alias（priority 53）→ 绕过 fontconfig 将 sans-serif 标准化为 sans 的问题
#
# ---- 如何调试 ----
# fc-list : family              # 列出所有发现的字体族名
# fc-match monospace            # 查看 monospace 匹配到哪个字体
# fc-match 'sans-serif:lang=zh' # 查看中文无衬线字体
# fc-match -s monospace | head  # 查看优先级排序（前 N 个）
# fc-list "PingFang SC" family  # 确认某个字体是否被发现
# FC_DEBUG=4 fc-match sans-serif 2>&1 | head  # 详细匹配过程

{ config, pkgs, lib, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  homeDir = config.home.homeDirectory;

  # macOS 字体搜索路径
  darwinFontDirs = lib.optionals isDarwin [
    "/System/Library/Fonts"                                   # 系统字体（SF Mono、Monaco 原版）
    "/System/Library/Fonts/Supplemental"                      # 补充字体（STHeiti 等）
    "/Library/Fonts"                                          # 全局用户安装字体
    "${homeDir}/Library/Fonts"                                # 当前用户字体（MonacoLigaturized）
    # PingFang 苹方（macOS Font Asset，路径随 macOS 版本变化）
    # 如字体找不到，运行: find /System/Library/AssetsV2 -name "PingFang*" 2>/dev/null
    "/System/Library/AssetsV2/com_apple_MobileAsset_Font8"
  ];
in
{
  fonts.fontconfig = {
    enable = true;

    # ---- 字体别名：将通用族名映射到具体字体 ----
    # 列表按优先级排列，生成 ~/.config/fontconfig/conf.d/52-hm-default-fonts.conf
    defaultFonts = {
      monospace = [
        "MonacoLigaturized"
        "JetBrainsMono Nerd Font Mono"
        "FiraCode Nerd Font Mono"
        "MesloLGS Nerd Font Mono"
        "PingFang SC"
        "Source Han Sans SC"
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

    # ---- 自定义 fontconfig 配置片段 ----
    configFile = lib.mkIf (darwinFontDirs != []) {
      # a) 注入 macOS 系统/用户字体目录（priority 10，最先加载）
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

      # b) fontconfig 内部将 "sans-serif" 标准化为 "sans"，
      #    defaultFonts.sansSerif 只匹配 "sans-serif"，因此需要额外 alias 匹配 "sans"
      #    priority 53 = 紧跟在 52-hm-default-fonts.conf 之后
      sans-alias = {
        enable = true;
        priority = 53;
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <alias binding="same">
              <family>sans</family>
              <prefer>
                <family>PingFang SC</family>
                <family>Source Han Sans SC</family>
              </prefer>
            </alias>
          </fontconfig>
        '';
      };
    };
  };

  home.packages = with pkgs; [
    # ---- 编程字体（Nerd Fonts，含图标补丁，跨平台） ----
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    # ---- CJK 字体（Linux 主力，macOS 作为系统字体补充） ----
    source-han-sans
    source-han-serif
    # ---- 字体调试工具 ----
    fontconfig                  # 提供 fc-list / fc-match 命令行工具
  ];
}
