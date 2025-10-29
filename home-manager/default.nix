{
  inputs,
  username,
  homeDirectory,
}: let
  homeManagerConfig = import ./home.nix {inherit inputs username homeDirectory;};
in {
  mkHomeManager = {system}:
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        homeManagerConfig

        inputs.sops-nix.homeManagerModules.sops
      ];

      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.nur.overlays.default
        ];
        config.allowUnfreePredicate = pkg:
          builtins.elem (inputs.nixpkgs.lib.getName pkg) [
            # NOTE: I hate unfree bc it won't get cached. Keeping the list the shortest possible.
            "crush" # NOTE: an unfree license (‘fsl11Mit’)
          ];
      };
    };
}
