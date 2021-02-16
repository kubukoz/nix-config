# nix-config

My Nix / nix-darwin / Home Manager config.

## Use

`darwin-rebuild switch`

![First time?](images/first-time.png)

1. [Install Brew](https://brew.sh)
2. [Install Nix](https://nixos.org/download.html)
3. [Generate ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
4. Pull this repo into `~/.nixpkgs`
5. `nix-shell -p gnupg git-crypt`
6. Generate gpg key: `gpg --gen-key`
7. Export key to `keyserver.ubuntu.com`
8. Import key on another machine with this
9. `git-crypt add-gpg-user`

## Manual steps that still need to be taken care of manually when making changes

- Symlink `~/.nix-channels` to this repo's channels file.
- Refresh channels (`nix-channel --update`, might need adding the channels to be tracked first).
- `mysudo` - see contents, copy it to sudoers.d - linking is not recommended to avoid inconsistencies while editing, which could break sudo.
