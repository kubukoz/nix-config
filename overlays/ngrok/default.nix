self: super: {
  ngrok = let
    printToken = "${self.bash}/bin/bash ${toString ./secret-ngrok.sh}";

    wrapper = self.writeScriptBin "ngrok"
      ''${super.ngrok}/bin/ngrok "$@" -authtoken $(${printToken});'';

  in self.symlinkJoin {
    name = "ngrok";
    paths = [ wrapper super.ngrok ];
  };
}
