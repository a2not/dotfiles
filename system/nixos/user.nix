{...}: let
  username = "n-honda";
  homeDirectory = "/home/${username}.linux";
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
