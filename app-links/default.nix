{ pkgs, config, lib, ... }:
let
  inherit (pkgs) symlinkJoin;
  mkAppLink = app:
    let
      appPath = "${app}/Applications/${app.mac-app.app}";
      resourcePath = "${appPath}/Contents/Resources/${app.mac-app.icon}";
      executableContent = ''
        #!/bin/bash
        open ${appPath}'';

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
          <string>icon.icns</string>
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
        mkdir -p Contents/Resources
        echo "${infoContent}" > Contents/Info.plist
        echo "${executableContent}" > "Contents/MacOS/run-wrapped"
        chmod +x Contents/MacOS/run-wrapped
        ln -s "${resourcePath}" "Contents/Resources/icon.icns"
        mkdir -p "$out/${app.mac-app.app}"
        cp -R Contents "$out/${app.mac-app.app}"
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
          app: ''
            cp -R "${mkAppLink app}/${app.mac-app.app}" ~/Applications''
        ) macApps
      )
    );
}
