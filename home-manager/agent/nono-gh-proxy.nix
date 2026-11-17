{
  pkgs,
  lib,
  # Toggle read-only L7 proxy filtering for the gh GitHub CLI. When true, all
  # gh API traffic is routed through a nono proxy credential that captures the
  # host token and enforces read-only L7 policy. When false, gh connects
  # directly with no L7 filtering.
  enableGitHubL7Proxy ? false,
}: {
  # Credential entry attached to the gh command sandbox; drives L7 endpoint
  # policy enforcement even if the argv layer allowed the subcommand.
  ghSandboxCredential = lib.optionals enableGitHubL7Proxy [
    {
      name = "github-api";
      endpoint_policy = {
        default = "deny";
        # Default deny blocks POST/PATCH/PUT/DELETE; only GET and GraphQL are allowed.
        allow = [
          {
            method = "GET";
            path = "/**";
          }
          {
            method = "POST";
            path = "/graphql";
          }
        ];
      };
    }
  ];

  # Supervisor-side credential capture: reads the active GitHub token from
  # gh's own config without exposing the config file to the sandboxed child.
  credentialCapture = lib.optionalAttrs enableGitHubL7Proxy {
    github_token = {
      command = ["gh" "auth" "token" "--hostname" "github.com"];
      timeout_secs = 5;
      cache_ttl_secs = 900;
      cache_path_regex = "^/(?:repos/|orgs/)?([^/]+)";
    };
  };

  # Proxy credential definition that intercepts api.github.com traffic and
  # injects the captured token as an Authorization header.
  commandCredential = lib.optionalAttrs enableGitHubL7Proxy {
    github-api = {
      type = "proxy";
      upstream = "https://api.github.com";
      credential_key = "cmd://github_token";
      env_var = "GH_TOKEN";
      inject_header = "Authorization";
      credential_format = "token {}";
    };
  };
}
