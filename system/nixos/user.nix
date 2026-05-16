{...}: let
  username = "n-honda";
  homeDirectory = "/home/${username}.guest";
in {
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
