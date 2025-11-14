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
          (final: prev: {
            opencode = inputs.nix-ai-tools.packages.${system}.opencode;
            amp = inputs.nix-ai-tools.packages.${system}.amp;
          })
        ];
      };
    };
}
