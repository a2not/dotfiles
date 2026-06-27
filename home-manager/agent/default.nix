{
  inputs,
  pkgs,
  config,
  ...
}: {
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
    "opencode/skills/grill-with-docs".source = "${inputs.mattpocock-skills}/skills/engineering/grill-with-docs";
    "opencode/skills/tdd".source = "${inputs.mattpocock-skills}/skills/engineering/tdd";
    "opencode/skills/codebase-design".source = "${inputs.mattpocock-skills}/skills/engineering/codebase-design";
    "opencode/skills/domain-modeling".source = "${inputs.mattpocock-skills}/skills/engineering/domain-modeling";
    "opencode/skills/implement".source = "${inputs.mattpocock-skills}/skills/engineering/implement";
    "opencode/skills/handoff".source = "${inputs.mattpocock-skills}/skills/productivity/handoff";

    "fence/fence.jsonc" = {
      source = ./fence/fence.jsonc;
    };
  };

  home.file = {
    ".pi/agent/AGENTS.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/AGENTS.md";
    ".pi/agent/mcp.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/mcp.json";
    ".pi/agent/models.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/models.json";
    ".pi/agent/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/settings.json";
    # NOTE: for updating extensions, check for the latest tagged version and pin by commit hash.
    # current extensions: (since settings.json can't have inline comment)
    # "git:github.com/mksglu/context-mode@bbeedad88550b09e77b09e6622689be7b5616c51",     # https://github.com/mksglu/context-mode/releases/tag/v1.0.167
    # "git:github.com/DietrichGebert/ponytail@025da371cd7539c3eb0ad859b08b3ca55e695f16", # https://github.com/DietrichGebert/ponytail/releases/tag/v4.8.3
    # "git:github.com/nicobailon/pi-subagents@e4f06282d0c95856b36b7ec2893f4fd294ebfefe", # https://github.com/nicobailon/pi-subagents/releases/tag/v0.31.0
    # "git:github.com/nicobailon/pi-web-access@7bdc30a65cf77273eb9c0034647b373bda4060d7" # https://github.com/nicobailon/pi-web-access/releases/tag/v0.13.0
    # "git:github.com/aliou/pi-guardrails@79f61e5a3f85484931487db0ed65887e96afc436"      # https://github.com/aliou/pi-guardrails/releases/tag/v0.15.0
    # NOTE: currently avoiding cloning them by flake.nix since some of them needs local node_modules writable but `/nix/store` is read only.
    ".pi/agent/extensions/guardrails.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/agent/pi/agent/extensions/guardrails.json";
  };
}
