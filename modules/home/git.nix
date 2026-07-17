{ localConfig, ... }:
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
  };
}
