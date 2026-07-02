{
  primaryUser,
  ...
}:
{
  imports = [
    ./git.nix
    ./shell.nix
    ./env.nix
  ];

  home = {
    homeDirectory = "/Users/${primaryUser}";
    username = primaryUser;
    stateVersion = "25.05";
  };
}
