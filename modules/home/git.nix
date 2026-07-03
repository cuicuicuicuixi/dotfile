let
  # 从 local.nix 读取（仓库中为占位值，使用 just config 填写真实信息）
  localFile = ./local.nix;
  localConfig =
    if builtins.pathExists localFile then import localFile else { gitUserName = ""; gitUserEmail = ""; };
in
{
  programs.git = {
    enable = true;

    # 全局 gitignore（所有仓库自动生效）
    ignores = [
      ".DS_Store"
      "Thumbs.db"
      "*~"
      "*.swp"
      "*.swo"
    ];

    settings = {
      user = {
        name = localConfig.gitUserName;
        email = localConfig.gitUserEmail;
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
      delta.features = "line-numbers decorations";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      alias.bdiff = "!batdiff"; # git bdiff → 带语法高亮的 diff
    };
    aliases = {
      bdiff = "!batdiff"; # git bdiff → 带语法高亮的 diff
    };
  };
}
