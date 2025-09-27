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
        "${config.sops.secrets."ssh_config/is".path}" # NOTE: is/rs
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

  sops = {
    secrets."ssh_config/cloud" = {};
    secrets."ssh_config/is" = {};
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
