{ pkgs, lib }:

let
  programsFromListFile = file:
    let
      autoProgramPaths = map (lib.splitString ".") (import file);
    in
      (map (path: lib.attrsets.getAttrFromPath path pkgs) autoProgramPaths);

in
{ inherit programsFromListFile; }
