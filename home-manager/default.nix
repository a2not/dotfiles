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
          inputs.llm-agents.overlays.shared-nixpkgs
          inputs.neovim-nightly-overlay.overlays.default
          # TODO: waiting for next version of ketch to fix check failure on darwin.
          # https://github.com/NixOS/nixpkgs/pull/547994#issuecomment-5306321643
          (self: super: {
            ketch = super.ketch.overrideAttrs (oldAttrs: {
              doCheck = !self.stdenv.hostPlatform.isDarwin;
            });
          })
          # HACK: temporary workaround for nix-functional-tests failing on aarch64-darwin. enable this when it starts to fail.
          # see https://github.com/NixOS/nix/issues/13106
          # (self: super: {
          #   nix =
          #     if self.stdenv.hostPlatform.isDarwin
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
            "copilot-language-server"
            "intelephense"
          ];
      };
    };
}
