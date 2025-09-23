{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system.nix
    ./packages.nix
  ];

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5; # nix-darwin specific

  modules = [
    ./lib/nix.nix
  ];
  specialArgs = {
    inherit pkgs;
  };
}
