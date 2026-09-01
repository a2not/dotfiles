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

    settings = {
      "*" = {
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = "~/.ssh/default.pub";
        controlMaster = "auto";
        controlPersist = "10m";
        controlPath = "~/.ssh/controlmasters/%r@%h:%p";
      };
    };

    extraConfig = (
      if isDarwin
      then ''
        Host *
          # NOTE: macos specific
          IgnoreUnknown UseKeychain
          UseKeychain yes
          AddKeysToAgent yes
          IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      ''
      else ""
    );
    includes = [
      "${config.sops.secrets."ssh_config/cloud".path}"
    ];
  };

  home.file.".ssh/default.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwngyM1+KxNLaSFhSYuilEgS36eqwaC8LV3GWd5Pu/z";

  # Ensure the socket directory exists
  home.activation.createSshSocketsDir = ''
    mkdir -p ~/.ssh/controlmasters
    chmod 700 ~/.ssh/controlmasters
  '';

  sops = {
    secrets."ssh_config/cloud" = {};
  };

  # NOTE: this is needed only on host but no harm having inside VM so keeping this unconditionally
  xdg.configFile."1Password/ssh/agent.toml" = {
    text = ''
      [[ssh-keys]]
      vault = "Private"
    '';
  };
}
