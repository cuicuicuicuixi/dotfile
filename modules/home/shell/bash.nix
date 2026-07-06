# Bash 配置（仅 Linux + my.shell = "bash" 时启用）
# ==================================================
# 作为 zsh 的后备方案，仅在明确指定使用 bash 的 Linux 机器上生效。
# macOS 始终使用 zsh（nix-darwin 不支持 bash 作为 login shell）。

{
  config,
  lib,
  pkgs,
  self,
  proxyAddr ? null,
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

    # 自定义 bashrc（代理函数 + 共享 shellrc.sh）
    bashrcExtra = ''
      # ---- 代理函数（地址由 local.nix proxyPort 在 build 时确定） ----
      ${
        if proxyAddr != null then ''
      on_proxy() {
          export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
          export http_proxy="${proxyAddr}"
          export https_proxy=$http_proxy
          export all_proxy="socks5://${lib.removePrefix "http://" proxyAddr}"
          echo -e "\033[32m代理已开启\033[0m"
      }
        '' else ''
      on_proxy() {
          echo -e "\033[31m未配置代理端口，请在 local.nix 中设置 proxyPort\033[0m"
          return 1
      }
        ''
      }
      off_proxy() {
          unset http_proxy
          unset https_proxy
          unset all_proxy
          echo -e "\033[31m代理已关闭\033[0m"
      }

      ${builtins.readFile "${self}/dotfiles/shellrc.sh"}
    '';
  };
}
