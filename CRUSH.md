# CRUSH Agent Instructions

## Build/Lint/Test Commands
- Apply home-manager config (Linux): `make home-linux`
- Apply home-manager config (Darwin): `make home-darwin`
- Update flake inputs: `make update`
- Cleanup Nix store: `make cleanup`
- Rebuild NixOS: `make nixos-rebuild`
- Rebuild Darwin: `make darwin-rebuild`
- Start Lima NixOS VM: `make lima-nixos-vm`

## Code Style Guidelines

### Nix
- Use consistent indentation (2 spaces)
- Follow existing patterns in flake.nix and module structures
- Prefer explicit parameter passing over implicit scope

### Lua (Neovim configs)
- Formatting: stylua with single quotes, 2-space indent (see .stylua.toml)
- Module structure: Return tables from modules
- Keymap conventions: Use which-key for organization
- Plugin config: Separate plugin configs into individual files under lua/plugins/

### General
- Naming: Use descriptive, consistent names
- Imports: Group and sort imports logically
- Error handling: Check for nil values and handle errors gracefully
- Documentation: Comment complex logic and public APIs
