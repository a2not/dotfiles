{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
  }: let
    configuration = {
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in {
    # nix-darwin
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./configuration.nix
        configuration

        ./nix-darwin

        nix-homebrew.darwinModules.nix-homebrew
        ./nix-homebrew
      ];
      specialArgs = {inherit inputs;};
    };
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
