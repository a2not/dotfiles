{
  config,
  pkgs,
  lib,
  ...
}: {
  time.timeZone = "Asia/Tokyo";

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/keys.txt";

    secrets = {
      "searxng/secret" = {};
    };

    templates."searx.env" = {
      content = ''
        SEARXNG_SECRET=${config.sops.placeholder."searxng/secret"}
      '';
      path = "/etc/searx.env";
      owner = config.users.users.searx.name;
      group = config.users.users.searx.group;
      mode = "0400";
    };
  };

  services.searx = {
    enable = true;
    environmentFile = config.sops.templates."searx.env".path;
    settings = {
      use_default_settings = true;
      server = {
        bind_address = "127.0.0.1";
        port = 18188;
        limiter = false;
        public_instance = false;
      };
      search = {
        formats = ["html" "json" "csv" "rss"];
      };
    };
  };
}
