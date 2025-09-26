{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system.nix
    ./packages.nix
    ./homebrew.nix
  ];

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5; # nix-darwin specific

  nix = {
    package = pkgs.nix;
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
        "@sudo"
      ];
      max-jobs = 8;
    };
    optimise.automatic = true;
    gc = {
      automatic = true;
      interval = [
        {
          Hour = 3;
          Minute = 15;
          Weekday = 7;
        }
      ];
      options = "--delete-older-than 7d";
    };
  };
}
