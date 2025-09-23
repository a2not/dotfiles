{
  pkgs,
  nixpkgs,
  ...
}: {
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    nixPath = ["nixpkgs=${nixpkgs}"];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
        "@sudo"
      ];
      auto-optimise-store = true;
      max-jobs = 8;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "daily";
      persistent = true;
      options = "--delete-older-than 7d";
    };
  };
}
