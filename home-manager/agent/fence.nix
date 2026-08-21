{ pkgs, lib }:

{
  "$schema" = "https://raw.githubusercontent.com/fencesandbox/fence/main/docs/schema/fence.schema.json";
  extends = "code-strict";
  network = {
    allowLocalBinding = true;
    allowLocalOutbound = true;
    allowLocalOutboundPorts = [3000 5173 5432 6379 8000 8080];
    allowedDomains = [
      # NixOS
      "search.nixos.org"
      "home-manager-options.extranix.com"
      # Sakura Internet
      "*.sakura.ad.jp"
      # Terraform
      "registry.terraform.io"
      # Go
      "*.pkg.go.dev"
      "proxy.golang.org"
      "sum.golang.org"
    ];
  };
  filesystem = {
    defaultDenyRead = true;
    allowGitConfig = true;
    allowRead = [
      "."
      "**/.git/hooks/**"
      "~/.ssh/agent/**" # git commit sign auth sock
      "~/.gitconfig*"
      "~/dotfiles/**"
      "~/.config/**"
      "~/.pi/**" # pi configurations and skills
      "/nix/**"
      "~/.nix-profile/**"
      "~/.cache/opencode/**"
      "~/go/**" # Go module/source cache
      "~/.cache/go-build/**" # Go build cache
    ];
    allowWrite = [
      "~/go/**"
      "~/.cache/go-build/**"
    ];
    allowExecute = [
      "~/.nix-profile/**"
      "**/.git/hooks/**"
    ];
  };
  allowPty = true;
}
// lib.optionalAttrs (!pkgs.stdenv.hostPlatform.isDarwin) {
  command = {
    runtimeExecPolicy = "argv";
    acceptSharedBinaryCannotRuntimeDeny = ["chroot"];
  };
}
