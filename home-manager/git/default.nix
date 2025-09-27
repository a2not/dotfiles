{...}: {
  programs.git = {
    enable = true;
    delta.enable = true;
    ignores = [
      ".aider*"
    ];
  };

  home.file = {
    ".gitconfig".source = ./.gitconfig;
    ".gitconfig_work".source = ./.gitconfig_work;
    ".gitconfig_mac".source = ./.gitconfig_mac;
    ".ssh/allowed_signers".source = ./allowed_signers;
  };
}
