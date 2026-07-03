let
  # 从 local.nix 读取（git tracked + assume-unchanged 保护本地修改）
  localFile = ./local.nix;
  localConfig =
    if builtins.pathExists localFile then import localFile else { gitUserName = ""; gitUserEmail = ""; };
in
{
  programs.git = {
    enable = true;
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
    };
  };
}
