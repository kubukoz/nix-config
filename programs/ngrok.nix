{ pkgs, config, ... }: {
  home.packages = [ pkgs.ngrok ];

  home.file.".ngrok2/ngrok.yml".text =
    builtins.toJSON { authtoken = config.secrets.ngrok.auth-token; };
}
