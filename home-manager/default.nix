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

        (_: {
          nixpkgs.overlays = [
            # charmbracelet/crush
            inputs.nur.overlays.default
          ];
        })
      ];

      pkgs = import inputs.nixpkgs {
        config.allowUnfree = true;
      };
    };
}
