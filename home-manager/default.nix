{inputs}: let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";

  homeManagerConfig = import ./home.nix {inherit inputs;};
in {
  mkHomeManager = {system}:
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        (homeManagerConfig {inherit username homeDirectory;})

        inputs.sops-nix.homeManagerModules.sops
      ];

      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };
}
