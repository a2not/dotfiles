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
    hm = import ./home-manager {inherit inputs username homeDirectory;};

    homeConfigurations = {
      aarch64-linux = self.hm.mkHomeManager {system = "aarch64-linux";};
      aarch64-darwin = self.hm.mkHomeManager {system = "aarch64-darwin";};
      x86_64-linux = self.hm.mkHomeManager {system = "x86_64-linux";};
      x86_64-darwin = self.hm.mkHomeManager {system = "x86_64-darwin";};
    };

    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs username homeDirectory;};
      modules = [
        ./nix-darwin
        {
	  # TODO: some of the stuffs probably not needed. remnants from the debugging stuffs
          nixpkgs.hostPlatform = "aarch64-darwin";
          nix.settings.extra-platforms = [ "x86_64-darwin" "aarch64-darwin" ];
          nixpkgs.config.allowUnsupportedSystem = true;
        }
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager.sharedModules = [
            inputs.sops-nix.homeManagerModules.sops
          ];
          users.users.${username}.home = "/Users/${username}";
          home-manager.users.${username} = import ./home-manager/home.nix {inherit inputs username homeDirectory;};
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
