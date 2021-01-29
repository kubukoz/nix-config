args:

let
  rev = "e19491e24c98c9da4900b7c890ded47f7bfb58ee";
  src = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.zip";
    sha256 = "1wfdndmic20n8srszh79pmic5268amj01xh1rnm09yrq9z2k7wiy";
  };
in import src ({ config.allowUnfree = true; } // args)
