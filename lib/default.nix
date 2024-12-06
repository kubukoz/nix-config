{ lib }:

let
  # Inputs:
  # file - path to the file containing a list of strings, which will be split by dots to create an attribute path
  # root - the object whose attributes will be searched for the path
  attributesFromListFile = { file, root }:
    let autoProgramPaths = map (lib.splitString ".") (import file);
    in (map (path: lib.attrsets.getAttrFromPath path root) autoProgramPaths);

in { inherit attributesFromListFile; }
