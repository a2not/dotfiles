{inputs, username, homeDirectory}: let
  homeManagerConfig = import ./home.nix {inherit inputs username homeDirectory;};
in {
  mkHomeManager = {system}:
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        homeManagerConfig

        inputs.sops-nix.homeManagerModules.sops
      ];

      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };
}
