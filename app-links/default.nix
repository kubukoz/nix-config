{ pkgs, config, lib, ... }:
let
  inherit (pkgs) symlinkJoin;
  mkAppFile = app: "${app.mac-app.label}.app";
  mkAppLink = app:
    let
      appFile = mkAppFile app;
      appPath = "${app}/Applications/${appFile}";
      resourcePath = "${appPath}/Contents/Resources";
      executableContent = ''
        #!/bin/bash
        open "${appPath}"'';

      infoContent = ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>CFBundleExecutable</key>
          <string>run-wrapped</string>
          <key>CFBundleGetInfoString</key>
          <string>${app.mac-app.label} ${app.version}</string>
          <key>CFBundleIconFile</key>
          <string>${app.mac-app.icon}</string>
          <key>CFBundleDisplayName</key>
          <string>${app.mac-app.label}</string>
          <key>CFBundleName</key>
          <string>${app.mac-app.label}</string>
          <key>CFBundleShortVersionString</key>
          <string>${app.version}</string>
          <key>CFBundleVersion</key>
          <string>${app.version}</string>
        </dict>
        </plist>
      '';
    in
      pkgs.runCommand "wrapper-${app.name}" {} ''
        mkdir -p Contents/MacOS
        echo "${infoContent}" > Contents/Info.plist
        echo '${executableContent}' > "Contents/MacOS/run-wrapped"
        chmod +x Contents/MacOS/run-wrapped
        ln -s "${resourcePath}" "Contents/Resources"
        mkdir -p "$out/${appFile}"
        cp -R Contents "$out/${appFile}"
      '';
  apps = config.home.packages;
  macApps = builtins.filter
    (lib.hasAttrByPath [ "mac-app" ])
    apps;
in
{
  home.activation.linkApps = lib.hm.dag.entryAfter [ "writeBoundary" ]
    (
      builtins.concatStringsSep "\n" (
        [ "mkdir ~/Applications" ] ++ map (
          app:
            let
              appFile = mkAppFile app;
            in
              ''
                cp -R "${mkAppLink app}/${appFile}" ~/Applications''
        ) macApps
      )
    );
}
