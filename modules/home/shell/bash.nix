# Bash 配置（仅 Linux + my.shell = "bash" 时启用）
# ==================================================
# Linux 登录 Shell 自动检测为 Bash 时，由 Home Manager 接管 Bash 配置。

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
      # ---- 代理函数（地址由本机私有配置的 proxyHost 和 proxyPort 在 build 时确定） ----
      ${import ./proxy-func.nix proxyAddr}

      ${builtins.readFile "${self}/dotfiles/shellrc.sh"}
    '';
  };
}
