{
  config,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes =
      [
        "${config.sops.secrets."ssh_config/cloud".path}"
      ]
      ++ (
        # NOTE: macos specific
        if isDarwin
        then [
          "${config.sops.secrets."ssh_config/macos".path}"
        ]
        else []
      );
  };

  home.file.".ssh/default.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwngyM1+KxNLaSFhSYuilEgS36eqwaC8LV3GWd5Pu/z";

  sops = {
    secrets."ssh_config/cloud" = {};
    secrets."ssh_config/macos" = {};
  };

  # NOTE: this is needed only on host but no harm having inside VM so keeping this unconditionally
  xdg.configFile."1Password/ssh/agent.toml" = {
    text = ''
      [[ssh-keys]]
      vault = "Private"
    '';
  };
}
