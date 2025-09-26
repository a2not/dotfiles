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
}
