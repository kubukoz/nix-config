# nix-config

My Nix / nix-darwin / Home Manager config.

## Use

`darwin-rebuild switch`

![First time?](images/first-time.png)

1. [Install Brew](https://brew.sh)
2. [Install Nix](https://nixos.org/download.html)
3. [Generate ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
4. Generate gpg key: `gpg --gen-key`
5. Export key to `keyserver.ubuntu.com`
6. Import key on another machine with this
7. `git-crypt add-gpg-user` on another machine
8. Pull this repo into `~/.nixpkgs`
9. `nix-shell -p gnupg git-crypt`
10. `git-crypt unlock`
11. Follow manual steps to symlink & refresh nix channels
12. [Install nix-darwin](https://github.com/LnL7/nix-darwin)

## Manual steps that still need to be taken care of manually when making changes

- `ln -s ~/.nixpkgs/.nix-channels ~/.nix-channels`
- Refresh channels (`nix-channel --update`, might need adding the channels to be tracked first).
- `mysudo` - see contents, copy it to sudoers.d - linking is not recommended to avoid inconsistencies while editing, which could break sudo.
