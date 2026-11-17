{
  pkgs,
  lib,
}: let
  gitPolicy = import ./nono-git.nix {inherit pkgs lib;};
in {
  extends = "nolabs-ai/pi";
  meta = {
    name = "sandbox";
    version = "1.0.0";
    description = "Pi development sandbox for Nix, mise, and Go";
  };
  groups = {
    # The base profile already includes Nix, Git config, Python, Rust, and
    # dangerous-command protections. Add only the development tools it lacks.
    include =
      ["go_runtime" "mise_manager"]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["go_runtime_linux"]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin ["go_runtime_macos"];
    # User caches may contain plaintext tokens and sensitive session data.
    # Exclude broad cache access; grant only specific tool cache directories.
    exclude = [
      "user_caches_linux"
      "user_caches_macos"
    ];
  };
  linux = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    # Default-deny pathname socket connect/bind, except explicit socket grants.
    af_unix_mediation = "pathname";
  };
  # The launcher grants the Git top-level, falling back to CWD outside Git.
  workdir.access = "readwrite";
  filesystem = {
    allow = [
      "/tmp"
      "$TMPDIR"
      "$XDG_CACHE_HOME/nix"
      "$XDG_CACHE_HOME/mise"
      "$XDG_STATE_HOME/mise"
      # Module downloads and checksum state, without making ~/go/bin writable.
      "$HOME/go/pkg"
      gitPolicy.scannerCache
    ];
    read = [
      "~/dotfiles"
      # Avoid exposing all of XDG_CONFIG_HOME, which may contain credentials.
      "$XDG_CONFIG_HOME/nix"
      "$XDG_CONFIG_HOME/mise"
      "$XDG_CONFIG_HOME/nvim"
      # Keep host-installed runtimes, shims, and plugins read-only. Install
      # tools outside Pi, or use project-local tool directories when needed.
      "$XDG_DATA_HOME/mise"
    ];
    # Allow libc's name-service cache lookups without opening other host sockets.
    # The signing socket is granted only to Git's ssh-keygen child.
    unix_socket = lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/run/nscd/socket"];
  };
  network = {
    block = false;
    # Only the local search service is available by default. Add database and
    # dev-server ports explicitly for tasks that need them.
    open_port = [18188];
    # Clear the inherited preset; explicit domains below are the whole list.
    network_profile = null;
    allow_domain = [
      # github -> https://docs.github.com/en/copilot/reference/copilot-allowlist-reference
      "github.com"
      "*.github.com"
      "*.githubassets.com"
      "*.githubusercontent.com"
      "*.githubcopilot.com"
      # Nix
      "search.nixos.org"
      "home-manager-options.extranix.com"
      "cache.nixos.org"
      # Terraform
      "registry.terraform.io"
      # Go
      "go.dev"
      "golang.org"
      "proxy.golang.org"
      "sum.golang.org"
      "pkg.go.dev"
      # pi
      "pi.dev"
      # nono
      "nono.sh"
      # Sakura is reachable only through its credential route, not a domain grant.
    ];
    credentials = ["sakura_ai_engine"];
    # https://nono.sh/docs/cli/features/credential-injection#profile-proxy-credential-injection
    custom_credentials = {
      sakura_ai_engine = {
        upstream = "https://api.ai.sakura.ad.jp/v1";
        # Read the real key from nono's host environment; Pi gets a phantom token.
        credential_key = "env://OPENAI_API_KEY";
        env_var = "OPENAI_API_KEY";
      };
    };
  };
  # This API-key workflow does not need the base profile's browser-login grants.
  open_urls = {
    allow_origins = [];
    allow_localhost = false;
  };
  allow_launch_services = false;

  environment = {
    # Match allow/deny patterns case-insensitively so secret-shaped vars are
    # caught regardless of capitalization.
    case_insensitive_vars = true;

    # Disable Pi's tmux hyperlink probe to avoid blocked Unix-socket connections
    # without granting access to the host tmux server.
    set_vars.PI_HYPERLINKS = "0";

    allow_vars = [
      # identity / shell basics
      "HOME"
      "USER"
      "LOGNAME"
      "SHELL"
      "PWD"
      "OLDPWD"
      "SHLVL"

      # terminal / locale
      "TERM"
      "TERMINFO"
      "TERM_PROGRAM"
      "COLORTERM"
      "LANG"
      "LC_*"
      "TZ"

      # temp
      "TMPDIR"

      # executable search
      "PATH"
      "MANPATH"
      "INFOPATH"

      # Nix toolchain
      "NIX_PATH"
      "NIX_PROFILES"
      "NIX_SSL_CERT_FILE"
      "NIX_USER_PROFILE_DIR"
      "SSL_CERT_FILE"

      # XDG base dirs
      "XDG_*"

      # editor / pager conveniences
      "EDITOR"
      "VISUAL"
      "PAGER"

      # nono runtime variables
      "NONO_*"
    ];

    # Always strip secret-shaped variables, even if they matched allow_vars.
    deny_vars = [
      "*TOKEN*"
      "*SECRET*"
      "*PASSWORD*"
      "*API_KEY*"
      "*PRIVATE*"
      "*CREDENTIAL*"

      # common provider / cloud secrets
      "AWS_ACCESS_KEY_ID"
      "AWS_SECRET_ACCESS_KEY"
      "GITHUB_TOKEN"
      "GITLAB_TOKEN"
      "OPENAI_API_KEY"
      "ANTHROPIC_API_KEY"
      "GOOGLE_API_KEY"
      "GEMINI_API_KEY"
    ];
  };

  command_policies = gitPolicy.command_policies;
}
