# nix-config

My Nix / nix-darwin / Home Manager config.

## Use

`darwin-rebuild switch --flake .`

![First time?](images/first-time.png)

1. [Install Brew](https://brew.sh)
2. [Install Nix](https://nixos.org/download.html)
3. [Generate ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key)
4. Generate gpg key: `gpg --gen-key`
5. Export key to `keyserver.ubuntu.com`
6. Import key on another machine with this
7. `git-crypt add-gpg-user` on another machine
8.  [Install nix-darwin](https://github.com/LnL7/nix-darwin)
9. Pull this repo into `~/.nixpkgs`
10. `nix-shell -p gnupg git-crypt`
11. `git-crypt unlock`
12. Follow manual steps to symlink & refresh nix channels

## Manual steps that still need to be taken care of manually when making changes

- iterm - move plist file to `~/Library/Preferences/com.googlecode.iterm2`
