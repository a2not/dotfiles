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

    nixos-lima = {
      url = "github:nixos-lima/nixos-lima/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    nixos-lima,
    nixos-generators,
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
      specialArgs = {inherit inputs;};
      modules = [
        ./nix-darwin
      ];
    };

    nixosConfigurations."lima" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit nixos-lima;};
      modules = [
        ./hardware/nixos
      ];
    };

    # TODO: needs linux-builder or nix-rosetta-builder to build
    # https://github.com/nixos-lima/nixos-lima/blob/master/README.md#prerequisites
    #
    # error: a 'aarch64-linux' with features {} is required to build '/nix/store/xxxxxxxx-X-Restart-Triggers-dhcpcd.drv',
    # but I am a 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
    img = nixos-generators.nixosGenerate {
      pkgs = import nixpkgs {system = "aarch64-linux";};
      specialArgs = {inherit nixos-lima;};
      modules = [
        ./hardware/nixos
      ];
      format = "qcow-efi";
    };
  };
}
