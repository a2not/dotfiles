# SSH config

## op-forward

Initial setup of op-forward. This enables you to use 1Password cli inside lima VM.

### Host
 
Install op-forward.

```sh
brew install ekovshilovsky/tap/op-forward
```

Persist op-forward service across reboots.

```sh
op-forward service install
```

Copy refresh token. This is automated so no need to run this, but if you wanna manually copy the token, you can do it like this.
Refer to [Automatic token deployment](#automatic-token-deployment) section for more details.

```sh
scp -F ~/.lima/default/ssh.config ~/Library/Caches/op-forward/refresh.token lima-default:~/.cache/op-forward/refresh.token
```

Start remote port forwarding from the lima VM to your local machine.
There are aliases for this, so choose one with the target VM names.

```sh
lima-default
lima-nixos
```

### Guest (Lima VM)

```sh
go install github.com/ekovshilovsky/op-forward@latest
op-forward install
```

### Automatic token deployment

[`xin/lima/nixos.yaml`](../../xin/lima/nixos.yaml) mounts the host directory
`~/Library/Caches/op-forward` read-only at `/mnt/op-forward-host`.
[`home-manager/zsh/default.nix`](../zsh/default.nix) adds a Linux-only `.zprofile`
hook that copies `refresh.token` on Zsh login, but only if the host token is
readable and the guest's `~/.cache/op-forward/refresh.token` does not exist.
The guest cache is writable and owned by the guest user, with `0600` permissions
for the token. Newly created directories have `0755` permissions; existing
directory permissions are left unchanged. Only the refresh token is copied;
op-forward obtains and caches its own access token.

Lima mounts directories, not individual files. Keep the guest cache writable:
op-forward rotates and saves both tokens. The host mount remains read-only.
This is bootstrap initialization, not synchronization: existing guest tokens
are never overwritten, even on later logins or VM restarts. Non-login commands
and background services do not trigger the copy.

Start the host service above before starting the VM and confirm it has generated
the token:

```sh
test -r ~/Library/Caches/op-forward/refresh.token
```

See [op-forward's token lifecycle](https://github.com/ekovshilovsky/op-forward/blob/main/docs/tokens.md)
for token rotation behavior.

Verify inside the guest without printing the token:

```sh
findmnt -T /mnt/op-forward-host/refresh.token  # Options should include ro.
test -r "$HOME/.cache/op-forward/refresh.token"
test -w "$HOME/.cache/op-forward/refresh.token"
stat -c '%a %n' "$HOME/.cache/op-forward" "$HOME/.cache/op-forward/refresh.token"
```

If the host token is missing or unreadable, the login hook silently skips the
copy and leaves any existing guest token untouched. Start the host service,
confirm the host token exists, and open a new Zsh login shell to retry.

If host reauthentication requires reseeding the guest, stop guest processes
using op-forward, remove only `~/.cache/op-forward/refresh.token`, and open a new
Zsh login shell. Do not remove a working guest token during normal operation.
