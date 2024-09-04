{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        node_22
        nvim
        jq
        lazygit
        zsh
      ];
    };
  };
}
