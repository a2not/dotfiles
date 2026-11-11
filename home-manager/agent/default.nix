{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  nonoConfig = import ./nono.nix {inherit pkgs lib;};
in {
  home.packages = with pkgs;
    [
      llm-agents.pi
      llm-agents.nono
      bash # AI agent needs this
      ketch # for pi web-search
      graphify
      fd # nono needs this
    ]
    ++ lib.optionals (!pkgs.stdenv.hostPlatform.isDarwin) [
      chromium # for ketch scrape for JS-rendered pages
    ];

  xdg.configFile = {
    "ketch/config.json" = {
      text = builtins.toJSON {
        backend = "searxng";
        searxng_url = "http://127.0.0.1:18188";
        available_backends = ["searxng"];
        browser = "${config.home.homeDirectory}/.nix-profile/bin/chromium";
      };
    };

    "nono/profiles/sandbox.json" = {
      text = builtins.toJSON nonoConfig;
    };
  };

  home.file = {
    ".pi/agent/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/AGENTS.md";
    ".pi/agent/models.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/models.json";
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/settings.json";
    ".pi/agent/prompts/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/prompts/";
    ".pi/agent/skills/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/skills";
    ".pi/agent/extensions/".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/extensions";
  };
}
