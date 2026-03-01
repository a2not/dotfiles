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
            crush = inputs.nix-ai-tools.packages.${system}.crush;
          })
          inputs.neovim-nightly-overlay.overlays.default
          # HACK: temporary workaround for nix-functional-tests failing on aarch64-darwin. enable this when it starts to fail.
          # see https://github.com/NixOS/nix/issues/13106
          # (self: super: {
          #   nix =
          #     if self.stdenv.isDarwin
          #     then
          #       super.nix.overrideAttrs (oldAttrs: {
          #         doCheck = false;
          #         doInstallCheck = false;
          #       })
          #     else super.nix;
          # })
        ];
        config.allowUnfreePredicate = pkg:
          builtins.elem (inputs.nixpkgs.lib.getName pkg) [
            "terraform"
          ];
      };
    };
}
