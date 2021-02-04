# nix-config

My Nix / nix-darwin / Home Manager config.

## Use

`darwin-rebuild switch`

## Manual steps that still need to be taken care of manually when making changes

- Symlink `~/.nix-channels` to this repo's channels file.
- Refresh channels (`nix-channel --update`, might need adding the channels to be tracked first).
- `mysudo` - see contents, copy it to sudoers.d - linking is not recommended to avoid inconsistencies while editing, which could break sudo.
