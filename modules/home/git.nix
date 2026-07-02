{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "cuicuicuicuixi";
        email = "849343517@qq.com";
      };
      init.defaultBranch = "main";
      core.editor = "nvim";
      delta.features = "line-numbers decorations";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };
}
