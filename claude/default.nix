{ pkgs, ... }:
{
  programs.claude-code = {
    enable = true;
    mcpServers = {
      github-com = {
        type = "stdio";
        command = "bash";
        args =
          let
            host = "github.com";
          in
          [
            "-c"
            (builtins.concatStringsSep " " [
              "GITHUB_PERSONAL_ACCESS_TOKEN=$(gh auth token --hostname=${host})"
              "GITHUB_HOST=https://${host}"
              "${pkgs.lib.getExe pkgs.github-mcp-server}"
              "stdio"
            ])
          ];
      };
    };
  };

  home.packages =
    let
      claude-personal = pkgs.writeShellScriptBin "claude-personal" ''
        #!/bin/bash
        exec ${pkgs.claude-code}/bin/claude "$@"
      '';
    in
    [
      claude-personal
    ];
}
