{
  description = "a2not NixOS/Ubuntu/Darwin configs with home-manager";

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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    ...
  }: let
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
  in {
    hm = import ./home-manager {inherit inputs;};

    homeConfigurations = {
      aarch64-linux = self.hm.mkHomeManager {system = "aarch64-linux";};
      aarch64-darwin = self.hm.mkHomeManager {system = "aarch64-darwin";};
      x86_64-linux = self.hm.mkHomeManager {system = "x86_64-linux";};
      x86_64-darwin = self.hm.mkHomeManager {system = "x86_64-darwin";};
    };

    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./nix-darwin
        {
          # TODO: support multiple systems with flake-parts
          nixpkgs.hostPlatform = "aarch64-darwin";
        }

        inputs.home-manager.darwinModules.home-manager
        inputs.sops-nix.homeManagerModules.sops # TODO: redundant with ./home-manager/default.nix
        {
          home-manager.users.${username} = import ./home-manager/home.nix {inherit inputs;} {inherit username homeDirectory;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
      specialArgs = {inherit inputs;};
    };
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}
