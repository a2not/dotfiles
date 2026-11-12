{
  pkgs,
  config,
  ...
}: let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  pnpmHome = "${config.home.homeDirectory}/.local/share/pnpm";
  mkLimaAlias = vmName: ''
    limactl start ${vmName} && \
      ssh -F ~/.lima/${vmName}/ssh.config \
      -o ExitOnForwardFailure=yes \
      -R 18340:127.0.0.1:18340 \
      lima-${vmName} \
      && limactl stop ${vmName}
  '';
  seedOpForwardToken = ''
    # Seed op-forward on login; never overwrite the guest's rotated token.
    if [[ -r /mnt/op-forward-host/refresh.token && ! -e "''${HOME}/.cache/op-forward/refresh.token" ]]; then
      ${pkgs.coreutils}/bin/install -D -m 600 \
        /mnt/op-forward-host/refresh.token \
        "''${HOME}/.cache/op-forward/refresh.token"
    fi
  '';
  loadLimaSharedTmpDir = ''
    # Read the VM name as root to derive /tmp/lima/{{.Name}}.
    load_lima_shared_tmp_dir() {
      [[ -n "''${LIMA_SHARED_TMP_DIR:-}" ]] && return 0

      local lima_name_line
      lima_name_line=$(sudo grep -m1 '^LIMA_CIDATA_NAME=' /mnt/lima-cidata/lima.env 2>/dev/null) || {
        echo "load_lima_shared_tmp_dir: failed to read LIMA_CIDATA_NAME from /mnt/lima-cidata/lima.env" >&2
        return 1
      }
      [[ -n "''${lima_name_line#*=}" ]] || {
        echo "load_lima_shared_tmp_dir: LIMA_CIDATA_NAME is empty" >&2
        return 1
      }
      export LIMA_SHARED_TMP_DIR="/tmp/lima/''${lima_name_line#*=}"
    }
  '';
  opLoadFrom = ''
    # Copy an env file under /tmp/lima so op-forward can resolve it on host, then load them as environment variables.
    op_load_from() {
      local _src="''${1:-}"
      [[ -r "$_src" ]] || { echo "op_load_from: missing or unreadable file: $_src" >&2; return 1; }

      load_lima_shared_tmp_dir || return
      local _dst="''${LIMA_SHARED_TMP_DIR}/op-forward/''${_src##*/}"
      ${pkgs.coreutils}/bin/install -D -m 600 "$_src" "$_dst" || return 1

      local resolved_env
      resolved_env=$(op inject --in-file "$_dst") || return
      source <(printf '%s\n' "$resolved_env")
    }
  '';
  opLoad = ''
    op_load() {
      op_load_from "${config.sops.secrets."work/zsh/env".path}"
    }
  '';
in {
  home.packages = with pkgs; [
    fzf
    starship
    zoxide
    ripgrep
    fastfetch
    jq

    gh
    lefthook
    betterleaks

    devenv

    mise
    gnupg

    terraform
    usacloud
    gopls
    golangci-lint
    rust-analyzer
    typescript-language-server
    bun
    phpactor
    python3
  ];

  home.sessionVariables = {
    # make it available to `pnpm install --global`
    PNPM_HOME = pnpmHome;
    # Disable usacloud version checks on every invocation.
    USACLOUD_NO_VERSION_CHECK = "true";
    # Share the sops-nix age key location with the `sops` CLI.
    SOPS_AGE_KEY_FILE = config.sops.age.keyFile;
  };
  home.sessionPath = [
    "${pnpmHome}/bin/"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true; # plugin "zsh-autosuggestions"
    syntaxHighlighting.enable = true; # plugin "zsh-syntax-highlighting"
    # NOTE: omz gives me sane defaults. For example, I prefer "{up,down}-line-or-beginning-search" keybindings to enabling zsh-history-substring-search.
    oh-my-zsh.enable = true;

    shellAliases =
      {
        ls = "eza";
        pi = "nono run --profile sandbox --allow-cwd --strict-broker-path -- pi";
        grok = "nono run --profile sandbox --allow-cwd --strict-broker-path -- grok";
      }
      // pkgs.lib.optionalAttrs isDarwin {
        lima-default = mkLimaAlias "default";
        lima-nixos = mkLimaAlias "nixos";
      };
    history = {
      append = true;
      extended = true;
      expireDuplicatesFirst = true;
      ignoreAllDups = true;
      ignoreDups = true;
      save = 10000;
      saveNoDups = true;
      share = true;
      size = 10000;
    };
    # https://discourse.nixos.org/t/programs-neovim-defaulteditor-true-kills-bindkey-for-autosuggest-accept-in-zsh/48844
    defaultKeymap = "emacs";

    profileExtra =
      ''
        export OPENAI_API_KEY="$(cat ${config.sops.secrets."openai/api_key".path})"
        source ${config.sops.secrets."work/zsh/profile".path}
      ''
      + pkgs.lib.optionalString isDarwin ''
        # NOTE: MacOS specific
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        op_load() {
          local resolved_env
          resolved_env=$(op inject --in-file "${config.sops.secrets."work/zsh/env".path}") || return
          source <(printf '%s\n' "$resolved_env")
        }
      ''
      + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux (
        seedOpForwardToken
        + loadLimaSharedTmpDir
        + opLoadFrom
        + opLoad
      );

    initContent =
      builtins.readFile ./.zshrc
      + pkgs.lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
        # Copy stdin to the host terminal's clipboard via OSC 52.
        pbcopy() {
          printf '\033]52;c;%s\a' "$(${pkgs.coreutils}/bin/base64 | ${pkgs.coreutils}/bin/tr -d '\r\n')"
        }
      '';

    # NOTE: align with new default value from home.stateVersion >= 26.05
    dotDir = "${config.xdg.configHome}/zsh";
  };

  home.file = {
    ".config/mise/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home-manager/zsh/mise.toml";
  };

  sops = {
    secrets = {
      "work/zsh/env" = {};
      "work/zsh/profile" = {};
      "openai/api_key" = {};
      "betterleaks/config" = {};
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "always";
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = pkgs.lib.importTOML ./starship.toml;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.mise = {
    enable = true;
    enableZshIntegration = true;
  };
}
