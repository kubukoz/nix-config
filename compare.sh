#!/bin/bash

darwin-rebuild build --flake ~/.nixpkgs
nix store diff-closures /run/current-system ./result
