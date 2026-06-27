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

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills";
      flake = false;
    };
    context-mode = {
      url = "github:mksglu/context-mode/v1.0.167";
      flake = false;
    };
    pi-subagents = {
      url = "github:nicobailon/pi-subagents/v0.31.0";
      flake = false;
    };
    pi-web-access = {
      url = "github:nicobailon/pi-web-access/v0.13.0";
      flake = false;
    };
    ponytail = {
      url = "github:DietrichGebert/ponytail/v4.8.3";
      flake = false;
    };

    nixos-lima = {
      url = "github:nixos-lima/nixos-lima";
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
    };

    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = {inherit inputs username;};
      modules = [
        ./system/darwin
      ];
    };

    nixosConfigurations."lima" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit nixos-lima;};
      modules = [
        ./system/nixos
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
        ./system/nixos
      ];
      format = "qcow-efi";
    };
  };
}
