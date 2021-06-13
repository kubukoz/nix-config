let
  programsFromTextFile = { pkgs, file }:
    let
      autoProgramPaths = map (pkgs.lib.splitString ".") (pkgs.lib.splitString "\n" (pkgs.lib.fileContents file));
    in
      (map (path: pkgs.lib.attrsets.getAttrFromPath recurse path pkgs) autoProgramPaths);

in
programsFromTextFile { inherit pkgs; file = ./programs/auto.txt; }
