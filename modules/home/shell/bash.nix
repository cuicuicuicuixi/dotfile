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
      ${import ./proxy-func.nix proxyAddr}

      ${builtins.readFile "${self}/dotfiles/shellrc.sh"}
    '';
  };
}
