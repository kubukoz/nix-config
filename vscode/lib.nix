let
  formatterSettings = { vscodeExtUniqueId, formatterFor }:
    let
      toLine = languageName: {
        name = "[${languageName}]";
        value = { "editor.defaultFormatter" = vscodeExtUniqueId; };
      };
    in
      builtins.listToAttrs (map toLine formatterFor);

  exclude = paths: let
    toObj = path: {
      name = "${path}";
      value = true;
    };
    obj = builtins.listToAttrs (map toObj paths);
  in
    {
      "files.watcherExclude" = obj;
      "files.exclude" = obj;
      "search.exclude" = obj;
    };

  mkVscodeModule = content: { programs.vscode = content; };

  configuredExtension =
    { extension, settings ? {}, keybindings ? [], formatterFor ? [] }:

      let
        baseModule = {
          userSettings = settings;
          inherit keybindings;
          extensions = [ extension ];
        };

        formattingModule = {
          userSettings =
            formatterSettings {
              inherit formatterFor;
              inherit (extension) vscodeExtUniqueId;
            };
        };
      in
        { imports = map mkVscodeModule [ baseModule formattingModule ]; };

  overrideKeyBinding = originalKey: setting: [
    setting
    (
      setting // {
        key = originalKey;
        command = "-${setting.command}";
      }
    )
  ];
in
{
  inherit configuredExtension overrideKeyBinding mkVscodeModule exclude;
}
