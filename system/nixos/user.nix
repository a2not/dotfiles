{
  config,
  pkgs,
  lib,
  username,
  homeDirectory,
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    home = homeDirectory;
    extraGroups = [
      "users"
      "wheel"
      "docker"
    ];
    useDefaultShell = true;
  };
}
