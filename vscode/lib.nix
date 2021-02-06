{ lib }:
let
  formatterSettings = { vscodeExtUniqueId, formatterFor }:
    let
      toLine = languageName: {
        name = "[${languageName}]";
        value = { "editor.defaultFormatter" = vscodeExtUniqueId; };
      };
    in
    builtins.listToAttrs (map toLine formatterFor);

  # Simplified version of https://stackoverflow.com/a/54505212
  # which also throws in the weird case
  mergeAll = with lib;
    zipAttrsWith (n: values:
      if tail values == [ ] then
      # only one value - keeping it
        head values
      else if all isList values then
      # all values are lists - concatenating
        unique (concatLists values)
      else if all isAttrs values then
      # all values are attrsets - merging recursively
        mergeAll values
      else
        throw "Duplicate, but unmergeable key: ${n}");

in
{
  inherit mergeAll;
  configuredExtension =
    { extension, settings ? { }, keybindings ? [ ], formatterFor ? [ ] }: {
      userSettings = mergeAll [
        settings
        (formatterSettings {
          inherit formatterFor;
          inherit (extension) vscodeExtUniqueId;
        })
      ];
      inherit keybindings;
      extensions = [ extension ];
    };
  overrideKeyBinding = originalKey: setting: [
    setting
    (setting // {
      key = originalKey;
      command = "-${setting.command}";
    })
  ];
}
