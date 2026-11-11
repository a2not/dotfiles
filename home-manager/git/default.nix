{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    ignores = [
      "node_modules/"
      "docs/superpowers/"
      ".superpowers/"
      "graphify-out/"
    ];
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  home.file = {
    ".gitconfig".source = ./.gitconfig;
    ".gitconfig_mac".source = ./.gitconfig_mac;
  };

  home.packages = with pkgs; [
    lazygit
  ];

  sops = {
    secrets = {
      "work/git/username" = {};
      "work/git/email" = {};
      "work/git/allowed_signers" = {};
    };
    templates = {
      "gitconfig_work" = {
        content = ''
          [user]
            name = ${config.sops.placeholder."work/git/username"}
            email = ${config.sops.placeholder."work/git/email"}
        '';
        path = "${config.home.homeDirectory}/.gitconfig_work";
      };
      "allowed_signers" = {
        content = ''
          31874975+a2not@users.noreply.github.com namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwngyM1+KxNLaSFhSYuilEgS36eqwaC8LV3GWd5Pu/z
          ${config.sops.placeholder."work/git/allowed_signers"}
        '';
        path = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
    };
  };
}
