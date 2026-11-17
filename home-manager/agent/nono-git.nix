{
  pkgs,
  lib,
  # Toggle read-only L7 proxy filtering for the gh GitHub CLI. When true, all
  # gh API traffic is routed through a nono proxy credential that captures the
  # host token and enforces read-only L7 policy. When false, gh connects
  # directly with no L7 filtering.
  enableGitHubL7Proxy ? false,
}: let
  sshSigner = "${pkgs.openssh}/bin/ssh-keygen";
  ghProxy = import ./nono-gh-proxy.nix {inherit pkgs lib enableGitHubL7Proxy;};
  gitContext = ["GIT_DIR" "GIT_WORK_TREE" "GIT_INDEX_FILE" "GIT_PREFIX"];
  # Root flags must match exactly: trailing flags could turn help/version off
  # and dispatch a different command. Bare auth status cannot expose its token.
  ghExactRules = [
    ["--version"]
    ["--help"]
    ["-h"]
    ["auth" "status"]
  ];
  # Non-mutating GitHub operations, with no child filesystem write grants.
  # Match specific leaf subcommands, not arbitrary arguments or command groups.
  # Prefix rules still accept flags; filesystem/exec gates are essential.
  # The real read-only enforcement is the L7 endpoint policy on the proxy,
  # so this list is defense-in-depth and controls error messages/UX.
  ghAllowRules = [
    ["status"]
    ["pr" "list"]
    ["pr" "view"]
    ["pr" "status"]
    ["pr" "checks"]
    ["pr" "diff"]
    ["issue" "list"]
    ["issue" "status"]
    ["issue" "view"]
    ["release" "list"]
    ["release" "view"]
    ["release" "verify"]
    ["release" "verify-asset"]
    ["repo" "list"]
    ["repo" "view"]
    ["repo" "gitignore" "list"]
    ["repo" "gitignore" "view"]
    ["repo" "license" "list"]
    ["repo" "license" "view"]
    ["repo" "read-dir"]
    ["repo" "read-file"]
    ["repo" "autolink" "list"]
    ["repo" "autolink" "view"]
    ["repo" "deploy-key" "list"]
    ["workflow" "list"]
    ["workflow" "view"]
    ["run" "list"]
    ["run" "view"]
    ["run" "watch"]
    ["cache" "list"]
    ["gist" "list"]
    ["gist" "view"]
    ["discussion" "list"]
    ["discussion" "view"]
    ["project" "list"]
    ["project" "view"]
    ["project" "field-list"]
    ["project" "item-list"]
    ["label" "list"]
    ["secret" "list"]
    ["variable" "list"]
    ["variable" "get"]
    ["search" "code"]
    ["search" "commits"]
    ["search" "issues"]
    ["search" "prs"]
    ["search" "repos"]
    ["org" "list"]
    ["ruleset" "check"]
    ["ruleset" "list"]
    ["ruleset" "view"]
    ["attestation" "verify"]
    ["attestation" "trusted-root"]
  ];
  ghSandbox =
    {
      fs_read = [
        "."
        "/nix/store"
        "~/.config/gh"
        "~/.config/git"
      ];
      # CA bundles for Linux and macOS; missing paths are skipped.
      fs_read_file = ["/etc/ssl/certs/ca-certificates.crt" "/etc/ssl/cert.pem"];
      # gh may write temporary files/caches; the config directory stays read-only.
      fs_write = ["/tmp"];
      fs_write_file = [];
      # When L7 proxying is enabled, all GitHub API traffic is routed through the
      # nono proxy credential. L7 endpoint policy allows only read operations,
      # regardless of argv. When disabled, gh gets direct outbound access.
      credentials = ghProxy.ghSandboxCredential;
      open_urls = {
        allow_origins = [];
        allow_localhost = false;
      };
      allow_launch_services = false;
      environment = {
        # Do not inherit the session proxy CA path, and strip tokens, debug
        # logging, editors, pagers, browser commands, and alternate GH_HOST.
        # GH_TOKEN is injected by the proxy credential.
        allow_vars = ["HOME" "USER" "LOGNAME" "LANG" "LC_*" "TZ" "TERM"];
        set_vars = {
          GH_TELEMETRY = "false";
          GH_NO_UPDATE_NOTIFIER = "1";
          GH_NO_EXTENSION_UPDATE_NOTIFIER = "1";
          GH_PROMPT_DISABLED = "1";
          GH_PAGER = "cat";
          # Also neutralize browser flag variants that token matchers cannot catch.
          GH_BROWSER = "${pkgs.coreutils}/bin/false";
          BROWSER = "${pkgs.coreutils}/bin/false";
        };
      };
      # Authentication uses the host's gh config for github.com. When the L7
      # proxy is enabled, the proxy credential captures the active token via
      # supervisor-side 'gh auth token' and injects it.
    }
    // lib.optionalAttrs (!enableGitHubL7Proxy) {
      network.allow_all = true;
    };
  # Scanner subprocesses get read-only checkout access and temporary storage.
  # Direct Git and Lefthook's Git manage the checkout; Lefthook refreshes hooks.
  hookSandbox = {
    fs_read = [
      "."
      "@git:toplevel"
      "@git:common-dir"
      "@git:hooks-path"
      "/nix/store"
      "/tmp"
      "$TMPDIR"
    ];
    # @git:config-files expands to files, not directories.
    fs_read_file = ["@git:config-files" "/dev/null" "/dev/urandom" "/bin/sh" "/bin/bash"];
    fs_write = ["/tmp" "$TMPDIR"];
    fs_write_file = ["/dev/null"];
    # Reading a hook is not enough: command sandboxes have an additional exec
    # gate. Allow installed hooks and their Nix-provided runtimes on Linux.
    exec_paths = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      "/nix/store"
      "@git:common-dir"
      "@git:hooks-path"
    ];
    # macOS has no typed exec_paths equivalent. Limit its command-scoped exec
    # exceptions to shell interpreters and repository-owned .git/hooks scripts;
    # Lefthook, Betterleaks, Git, and ssh-keygen still go through their shims.
    # A custom hooksPath outside .git/hooks needs its own explicit exec rule.
    unsafe_macos_seatbelt_rules = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      ''(allow process-exec* (literal "/bin/sh") (literal "/bin/bash") (literal "/private/var/select/sh") (literal "/var/select/sh") (subpath "${pkgs.bash}"))''
      ''(allow process-exec* (regex #"/[.]git/hooks/[^/]+$"))''
    ];
    network.allow_all = false;
    environment = {
      # Do not carry hook-skipping variables such as LEFTHOOK=0 or LEFTHOOK_SKIP
      # into the command chain. Credentials are injected only into the signer.
      allow_vars =
        [
          "HOME"
          "USER"
          "LOGNAME"
          "LANG"
          "LC_*"
          "TZ"
          "TERM"
          "TMPDIR"
          "EDITOR"
          "VISUAL"
          "GIT_AUTHOR_*"
          "GIT_COMMITTER_*"
        ]
        ++ gitContext;
      set_vars = {
        GIT_OPTIONAL_LOCKS = "0";
        GIT_TERMINAL_PROMPT = "0";
      };
    };
  };
  # Betterleaks depends on wazero via go-re2 and needs read+write access to
  # these cache directories to load and store compiled WebAssembly modules.
  scannerCache =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "$HOME/Library/Caches/com.github.wasilibs"
    else "$HOME/.cache/com.github.wasilibs";
  # Betterleaks itself only needs to execute the broker's Git shim.
  scannerSandbox =
    builtins.removeAttrs hookSandbox ["exec_paths" "unsafe_macos_seatbelt_rules"]
    // {
      fs_read =
        hookSandbox.fs_read
        ++ [
          scannerCache
          # Betterleaks reads its sops-nix-managed config from this symlinked path.
          "$HOME/.config/sops-nix/secrets/betterleaks"
        ];
      fs_write = hookSandbox.fs_write ++ [scannerCache];
    };
  gitReadSandbox =
    hookSandbox
    // {
      # Nix's Git may re-exec its packaged helpers by absolute path.
      unsafe_macos_seatbelt_rules =
        hookSandbox.unsafe_macos_seatbelt_rules
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          ''(allow process-exec* (subpath "${pkgs.git}"))''
        ];
      # Keep hooks enabled. Use OpenSSH with the agent on both Linux and macOS,
      # rather than needing direct 1Password app/keychain access on macOS.
      argv_prepend = [
        "--no-pager"
        "-c"
        "core.fsmonitor=false"
        "-c"
        "maintenance.auto=false"
        "-c"
        "gc.auto=0"
        "-c"
        "credential.helper="
        "-c"
        "protocol.allow=never"
        "-c"
        "gpg.format=ssh"
        "-c"
        "commit.gpgsign=true"
        "-c"
        # Use the shim name; the command policy pins it to sshSigner below.
        "gpg.ssh.program=ssh-keygen"
      ];
    };
in {
  # The session must grant this cache as well as the scanner's child sandbox.
  inherit scannerCache;

  # Supervisor-side credential capture: reads the active GitHub token from
  # gh's own config without exposing the config file to the sandboxed child.
  credential_capture = ghProxy.credentialCapture;

  command_policies = {
    approval_backends = {
      terminal = {
        type = "terminal";
      };
    };
    approval_defaults = {
      backend = "terminal";
    };
    credentials =
      {
        ssh-signing-agent = {
          type = "local-socket";
          # Resolved from the supervisor's host environment, not passed to Pi.
          path = "$SSH_AUTH_SOCK";
          mode = "connect";
          env_var = "SSH_AUTH_SOCK";
        };
      }
      // ghProxy.commandCredential;
    commands = {
      sudo.from.session = "deny";

      gh = {
        # Pin the real executable; ghSandbox restores the wrapper's telemetry opt-out.
        executable = "${pkgs.gh}/bin/.gh-wrapped";
        can_use = ["git"];
        from.session = {
          sandbox = ghSandbox;
          invocation_policy = {
            default = "deny";
            # Reject common browser flags early. The sandbox blocks URL opening
            # even for variants or short-flag clusters not matched here.
            deny = map (flag: {argv.contains = [flag];}) ["--web" "-w"];
            allow =
              map (exact: {argv.exact = exact;}) ghExactRules
              ++ map (prefix: {argv.prefix = prefix;}) ghAllowRules;
          };
        };
      };
      git = {
        executable = lib.getExe pkgs.git;
        can_use = ["lefthook" "ssh-keygen"];
        # Preserve alternate-index/worktree context through the hook chain.
        export_env = gitContext;
        from = {
          session = {
            sandbox =
              gitReadSandbox
              // {
                fs_write = hookSandbox.fs_write ++ ["@git:toplevel" "@git:common-dir"];
              };
            invocation_policy = {
              default = "deny";
              # Reject common explicit hook/signature bypasses. This is not
              # tamper-proof: the agent can still edit repository-owned hooks.
              deny = [
                {argv.contains = ["--no-verify"];}
                {argv.prefix = ["commit" "-n"];}
                {argv.contains = ["--no-gpg-sign"];}
              ];
              # -s adds Signed-off-by; commit.gpgsign=true also SSH-signs it.
              # Leading -c/--git-dir/-C options and aliases remain denied.
              # Commands that mutate the checkout or worktree require explicit
              # terminal approval.
              approve = map (command: {argv.prefix = [command];}) [
                "add"
                "commit"
                "worktree"
              ];
              allow =
                map (command: {argv.prefix = [command];}) [
                  "status"
                  "diff"
                  "log"
                  "show"
                  "ls-files"
                  "ls-tree"
                  "rev-parse"
                  "rev-list"
                  "cat-file"
                  "diff-index"
                  "diff-files"
                  "describe"
                  "merge-base"
                  "for-each-ref"
                  "show-ref"
                  "grep"
                  "check-ignore"
                  "check-attr"
                ]
                ++ [
                  {argv.prefix = ["branch" "--list"];}
                ];
            };
          };
          # Leave the self edge implicit: nested Git helpers must retain the
          # effective caller sandbox, including stash/restore write access.
          # Lefthook hides and restores unstaged edits in partially staged files.
          lefthook.sandbox =
            gitReadSandbox
            // {
              fs_write = hookSandbox.fs_write ++ ["@git:toplevel" "@git:common-dir"];
            };
          # GitHub's repository discovery stays read-only and offline, with no
          # temporary-directory writes inherited from the hook sandbox.
          gh.sandbox = gitReadSandbox // {fs_write = [];};
          # Secret scanning and its nested Git helpers remain read-only.
          betterleaks.sandbox = gitReadSandbox;
        };
      };
      lefthook = {
        executable = lib.getExe pkgs.lefthook;
        can_use = ["git" "betterleaks"];
        export_env = gitContext;
        from = {
          # Allow direct session invocation for the same safe argv patterns.
          # This covers terminal usage, IDE integrations, and any hook chain
          # where nono sees the shim parent rather than Git.
          session = {
            sandbox =
              hookSandbox
              // {
                fs_read = hookSandbox.fs_read ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/pts"];
                fs_read_file = hookSandbox.fs_read_file ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/ptmx"];
                fs_write = hookSandbox.fs_write ++ ["@git:common-dir"] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/pts"];
                fs_write_file = hookSandbox.fs_write_file ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/ptmx"];
              };
            invocation_policy = {
              default = "deny";
              allow = [
                {argv.exact = ["-h"];}
                {argv.prefix = ["run" "pre-commit"];}
              ];
            };
          };
          git = {
            # Lefthook can synchronize installed hooks. Its Git subprocesses
            # get separate checkout write access for unstaged-edit backup.
            sandbox =
              hookSandbox
              // {
                # Lefthook allocates a PTY for hook output on Linux. Grant the
                # master and dynamic slaves only to Lefthook, not the scanner.
                fs_read = hookSandbox.fs_read ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/pts"];
                fs_read_file = hookSandbox.fs_read_file ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/ptmx"];
                fs_write = hookSandbox.fs_write ++ ["@git:common-dir"] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/pts"];
                fs_write_file = hookSandbox.fs_write_file ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux ["/dev/ptmx"];
              };
            invocation_policy = {
              default = "deny";
              allow = [
                # The generated hook probes lefthook before running it.
                {argv.exact = ["-h"];}
                {argv.prefix = ["run" "pre-commit"];}
              ];
            };
          };
        };
      };
      betterleaks = {
        executable = lib.getExe pkgs.betterleaks;
        can_use = ["git"];
        export_env = gitContext;
        from = {
          session = "deny";
          lefthook = {
            sandbox = scannerSandbox;
            invocation_policy = {
              default = "deny";
              allow = [{argv.prefix = ["git" "--pre-commit"];}];
            };
          };
        };
      };
      ssh-keygen = {
        executable = sshSigner;
        from = {
          session = "deny";
          git = {
            sandbox = {
              fs_read = ["/nix/store" "/tmp" "$TMPDIR"];
              fs_read_file = ["~/.ssh/allowed_signers" "/dev/null" "/dev/urandom"];
              fs_write = ["/tmp" "$TMPDIR"];
              fs_write_file = ["/dev/null"];
              use_credentials = ["ssh-signing-agent"];
              network.allow_all = false;
            };
            invocation_policy = {
              default = "deny";
              allow = [
                {argv.prefix = ["-Y" "sign" "-n" "git"];}
                # Needed for git log/show --show-signature and verification.
                {argv.prefix = ["-Y" "find-principals"];}
                {argv.prefix = ["-Y" "verify"];}
                {argv.prefix = ["-Y" "check-novalidate"];}
              ];
            };
          };
        };
      };
    };
  };
}
