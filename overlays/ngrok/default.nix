self: super: {
  ngrok = self.symlinkJoin {
    name = "ngrok";
    paths = [ super.ngrok ];
    buildInputs = [ self.makeWrapper ];
    postBuild = ''
      TOKEN=$(${self.bash}/bin/bash ${toString ./secret-ngrok.sh})
      wrapProgram $out/bin/ngrok \
        --add-flags "-authtoken $TOKEN"
    '';
  };
}
