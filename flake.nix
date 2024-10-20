{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
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
      ];
      specialArgs = {inherit inputs;};
    };
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
