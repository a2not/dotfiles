{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    nix-homebrew,
    ...
  }: {
    lib = import ./lib {inherit inputs;};

    homeConfigurations = {
      aarch64-linux = self.lib.mkHomeManager {system = "aarch64-linux";};
      aarch64-darwin = self.lib.mkHomeManager {system = "aarch64-darwin";};
      x86_64-linux = self.lib.mkHomeManager {system = "x86_64-linux";};
      x86_64-darwin = self.lib.mkHomeManager {system = "x86_64-darwin";};
    };

    # nix-darwin
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./configuration.nix
        {
          # TODO: support multiple systems with flake-parts
          nixpkgs.hostPlatform = "aarch64-darwin";
        }

        ./nix-darwin

        nix-homebrew.darwinModules.nix-homebrew
        ./nix-homebrew
      ];
      specialArgs = {inherit inputs;};
    };
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
