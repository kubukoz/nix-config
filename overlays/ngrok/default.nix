self: super:
let
  printToken = "${self.bash}/bin/bash ${toString ./secret-ngrok.sh}";
  wrapper = self.writeScriptBin "ngrok"
    ''${super.ngrok}/bin/ngrok "$@" -authtoken $(${printToken});'';

in {
  ngrok = self.symlinkJoin {
    name = "ngrok-wrapper";
    paths = [ wrapper super.ngrok ];
  };
}
