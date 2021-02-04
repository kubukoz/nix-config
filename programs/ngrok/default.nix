{ pkgs, config, ... }: {
  home.packages = [ pkgs.ngrok ];

  home.file.".ngrok2/ngrok.yml".source =
    config.lib.file.mkOutOfStoreSymlink ./secret-ngrok.yml;
}
