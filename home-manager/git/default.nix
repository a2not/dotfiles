{config, ...}: {
  programs.git = {
    enable = true;
    ignores = [];
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  home.file = {
    ".gitconfig".source = ./.gitconfig;
    ".gitconfig_mac".source = ./.gitconfig_mac;
  };

  sops = {
    secrets = {
      "work/email" = {};
      "work/allowed_signers" = {};
    };
    templates = {
      "gitconfig_work" = {
        content = ''
          [user]
            name = n-honda
            email = ${config.sops.placeholder."work/email"}
        '';
        path = "${config.home.homeDirectory}/.gitconfig_work";
      };
      "allowed_signers" = {
        content = ''
          31874975+a2not@users.noreply.github.com namespace="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwngyM1+KxNLaSFhSYuilEgS36eqwaC8LV3GWd5Pu/z
          ${config.sops.placeholder."work/allowed_signers"}
        '';
        path = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
    };
  };
}
