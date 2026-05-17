{...}: let
  # NOTE: sudo nixos-rebuild can't receive $USER and $HOME since it'll fallback to root's.
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
