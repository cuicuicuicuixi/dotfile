# Bash 配置（仅 Linux + my.shell = "bash" 时启用）
# ==================================================
# 作为 zsh 的后备方案，仅在明确指定使用 bash 的 Linux 机器上生效。
# macOS 始终使用 zsh（nix-darwin 不支持 bash 作为 login shell）。

{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf (config.my.shell == "bash" && pkgs.stdenv.isLinux) {
  programs.bash = {
    enable = true;

    # 历史记录
    historySize = 1000000;
    historyFileSize = 1000000;

    # 别名（与 zsh 共用同一份定义）
    shellAliases = import ./aliases.nix;

    # bashrc 附加内容（发行版检测、代理、fastfetch 等——与 zshrc.sh 对应）
    bashrcExtra = ''
      # fnm (Node.js 版本管理)
      eval "$(fnm env)"

      # 发行版检测（用于 starship 图标）
      LFILE="/etc/os-release"
      MFILE="/System/Library/CoreServices/SystemVersion.plist"
      if [[ -f $LFILE ]]; then
        _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
      elif [[ -f $MFILE ]]; then
        _distro="macos"
      fi

      case $_distro in
          *kali*)                  ICON="ﴣ";;
          *arch*)                  ICON=" ";;
          *debian*)                ICON=" ";;
          *raspbian*)              ICON=" ";;
          *ubuntu*)                ICON=" ";;
          *elementary*)            ICON=" ";;
          *fedora*)                ICON=" ";;
          *coreos*)                ICON=" ";;
          *gentoo*)                ICON=" ";;
          *mageia*)                ICON=" ";;
          *centos*)                ICON=" ";;
          *opensuse*|*tumbleweed*) ICON=" ";;
          *sabayon*)               ICON=" ";;
          *slackware*)             ICON=" ";;
          *linuxmint*)             ICON=" ";;
          *alpine*)                ICON=" ";;
          *aosc*)                  ICON=" ";;
          *nixos*)                 ICON=" ";;
          *devuan*)                ICON=" ";;
          *manjaro*)               ICON=" ";;
          *rhel*)                  ICON=" ";;
          *macos*)                 ICON=" ";;
          *)                       ICON=" ";;
      esac

      export STARSHIP_DISTRO="$ICON"

      # 代理函数
      function on_proxy() {
          export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
          export http_proxy="http://127.0.0.1:7890"
          export https_proxy=$http_proxy
          export all_proxy=socks5://127.0.0.1:7890
          echo -e "\n"
          echo -e "\033[32m代理已开启\033[0m"
      }

      function off_proxy(){
          unset http_proxy
          unset https_proxy
          unset all_proxy
          echo -e "\033[31m代理已关闭\033[0m"
      }

      # fastfetch 启动展示
      if command -v fastfetch >/dev/null 2>&1; then
          fastfetch --config "$HOME/.config/fastfetch/startup.jsonc"
      fi
    '';
  };
}
