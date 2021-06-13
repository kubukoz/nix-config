{ pkgs, lib }:

let
  programsFromTextFile = file:
    let
      autoProgramPaths = map (lib.splitString ".") (lib.splitString "\n" (lib.fileContents file));
    in
      (map (path: lib.attrsets.getAttrFromPath path pkgs) autoProgramPaths);

in
{ inherit programsFromTextFile; }
