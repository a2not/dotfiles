{...}: {
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    # TODO: inject username depending on the machine
    user = "$whoami";
    autoMigrate = true;
  };
}
