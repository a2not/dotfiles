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

        # charmbracelet/crush
        (_: {
          nixpkgs.overlays = [
            inputs.nur.overlays.default
          ];
        })
      ];

      # pkgs = inputs.nixpkgs.legacyPackages.${system};
      pkgs = import inputs.nixpkgs {config = {allowUnfree = true;};};
    };
}
