{ config, lib, ... }:
with lib; {
  #
  options.secrets = mkOption { type = types.attrs; };
}
