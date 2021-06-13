{ vscode-lib }:
let
  inherit (vscode-lib) overrideKeyBinding;
in
[
  {
    key = "cmd+k cmd+n";
    command = "explorer.newFile";
  }
  {
    key = "cmd+k cmd+b";
    command = "explorer.newFolder";
  }
  {
    key = "alt+cmd+z";
    command = "git.revertSelectedRanges";
  }
] ++ overrideKeyBinding "f2" {
  key = "cmd+r cmd+r";
  command = "editor.action.rename";
  when =
    "editorHasRenameProvider && editorTextFocus && !editorReadonly";
} ++ overrideKeyBinding "shift-alt+f5" {
  key = "ctrl+shift+alt+up";
  command = "workbench.action.editor.previousChange";
  when = "editorTextFocus";
} ++ overrideKeyBinding "alt+f5" {
  key = "ctrl+shift+alt+down";
  command = "workbench.action.editor.nextChange";
  when = "editorTextFocus";
}
