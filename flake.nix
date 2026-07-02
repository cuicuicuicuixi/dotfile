{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      primaryUser = "user";

      configuration =
        { pkgs, ... }:
        {
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake .#MacBook-Pro
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ./setting.nix
          ./pkgs.nix
          ./homebrew.nix
          ./fonts.nix
          home-manager.darwinModules.home-manager
          ./home_manager.nix
        ];
        specialArgs = { inherit inputs self primaryUser; };
      };
    };
}
