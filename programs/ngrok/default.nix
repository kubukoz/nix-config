{ pkgs, config, ... }: {
  home.packages = [ pkgs.ngrok ];

  home.file.".ngrok2/ngrok.yml".source =
    # a bit hacky, but I'll deal with this next time
    config.lib.file.mkOutOfStoreSymlink ~/.nixpkgs/programs/ngrok/secret-ngrok.yml;
}
