{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  fenceConfig = import ./fence.nix {inherit pkgs lib;};
in {
  home.packages = with pkgs;
    [
      llm-agents.opencode
      llm-agents.fence
      llm-agents.pi
      bash # AI agent needs this
      ketch # for pi web-search
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
      chromium # for ketch scrape for JS-rendered pages
    ];

  xdg.configFile = {
    "opencode" = {
      source = ./opencode;
      recursive = true;
    };

    "fence/fence.json" = {
      text = builtins.toJSON fenceConfig;
    };

    "ketch/config.json" = {
      text = builtins.toJSON {
        backend = "searxng";
        searxng_url = "http://127.0.0.1:18188";
        available_backends = ["searxng"];
        browser = "${config.home.homeDirectory}/.nix-profile/bin/chromium";
      };
    };
  };

  home.file = {
    ".pi/agent/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/AGENTS.md";
    ".pi/agent/models.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/models.json";
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/settings.json";
    # NOTE: for updating extensions, check for the latest tagged version and pin by commit hash.
    # current extensions: (since settings.json can't have inline comment)
    # "git:github.com/DietrichGebert/ponytail@0a4dd63ad4541f4f655c4108a295916f3c1d8fda", # https://github.com/DietrichGebert/ponytail/releases/tag/v4.9.0
    # "git:github.com/nicobailon/pi-subagents@57fda3f9c66e961ae0bba26496ce6459226f886e", # https://github.com/nicobailon/pi-subagents/releases/tag/v0.64.0
    # "git:github.com/aliou/pi-guardrails@bec4c8be8ed93cf9ba28e3034ec8553e0b5cea6c"      # https://github.com/aliou/pi-guardrails/releases/tag/v0.17.1
    # NOTE: currently avoiding cloning them by flake.nix since some of them needs local node_modules writable but `/nix/store` is read only.
    ".pi/agent/extensions/guardrails.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/extensions/guardrails.json";
    ".pi/agent/prompts/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/prompts/";
    ".pi/agent/skills/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/skills";
  };
}
