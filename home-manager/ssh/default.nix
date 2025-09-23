{config, ...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "${config.sops.secrets."ssh_config/cloud".path}"
      # "${config.sops.secrets."ssh_config/is".path}" # NOTE: is/rs
      # "${config.sops.secrets."ssh_config/macos".path}" # NOTE: macos specific
    ];
  };

  sops = {
    secrets."ssh_config/cloud" = {};
    # secrets."ssh_config/is" = {};
    # secrets."ssh_config/macos" = {};
  };

  # NOTE: refer from nix environment when I'm outside of nix.
  # this does not mean that it got credentials, but just I'm being extra cautious.
  # home.file = {
  #   ".ssh/config".source = ./config;
  # };
}
