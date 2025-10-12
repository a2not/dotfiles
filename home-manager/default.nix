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
        config.allowUnfree = true;
      };
    };
}
