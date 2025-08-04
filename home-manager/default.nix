{inputs}: let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
  email = "31874975+a2not@users.noreply.github.com";
  git = {
    extraConfig.github.user = username;
    userEmail = email;
    userName = "a2not";
  };

  homeManagerConfig = import ./home.nix {inherit inputs;};
in {
  mkHomeManager = {system}:
    inputs.home-manager.lib.homeManagerConfiguration {
      modules = [
        (homeManagerConfig {inherit git homeDirectory username;})
      ];

      pkgs = inputs.nixpkgs.legacyPackages.${system};
    };
}
