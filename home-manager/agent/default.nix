{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  fenceConfig = import ./fence.nix {inherit pkgs lib;};
in {
  home.packages = with pkgs; [
    llm-agents.opencode
    llm-agents.fence
    llm-agents.pi
    bash # AI agent needs this
  ];

  xdg.configFile = {
    "opencode" = {
      source = ./opencode;
      recursive = true;
    };

    "fence/fence.json" = {
      text = builtins.toJSON fenceConfig;
    };
  };

  home.file = {
    ".pi/agent/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/AGENTS.md";
    ".pi/agent/models.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/models.json";
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/settings.json";
    # NOTE: for updating extensions, check for the latest tagged version and pin by commit hash.
    # current extensions: (since settings.json can't have inline comment)
    # "git:github.com/DietrichGebert/ponytail@0a4dd63ad4541f4f655c4108a295916f3c1d8fda", # https://github.com/DietrichGebert/ponytail/releases/tag/v4.9.0
    # "git:github.com/nicobailon/pi-subagents@c91f4de5ea956f0d1fcab9e44eba079fa2f917dd", # https://github.com/nicobailon/pi-subagents/releases/tag/v0.53.0
    # "git:github.com/nicobailon/pi-web-access@3b875f574840eebae39e5fede0d99a5f7c71f482" # https://github.com/nicobailon/pi-web-access/releases/tag/v0.24.0
    # "git:github.com/aliou/pi-guardrails@a3da058432e33999ed368b7a2ec5c72cc2187de2"      # https://github.com/aliou/pi-guardrails/releases/tag/v0.17.0
    # NOTE: currently avoiding cloning them by flake.nix since some of them needs local node_modules writable but `/nix/store` is read only.
    ".pi/agent/extensions/guardrails.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/extensions/guardrails.json";
    ".pi/web-search.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/web-search.json";
    ".pi/agent/prompts/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/prompts/";
  };
}
