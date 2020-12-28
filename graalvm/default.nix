{ stdenv, setJavaClassPath, freetype }:

let
  version = "20.3.0";
  arch = "darwin-amd64";
  # sources = fetchTarball {
  #   url =
  #     "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${version}/graalvm-ce-java11-${arch}-${version}.tar.gz";
  #   sha256 = "22b869fbf590c461278efae5e06fdd5ba32b4d5b302da838d9f50cb71aa20d01";
  # };
  sources = ./graalvm-ce-java11-darwin-amd64-20.3.0.tar.gz;

  jdk = stdenv.mkDerivation {
    name = "graalvm-${version}";
    src = sources;
    buildInputs = [ freetype ];

    installPhase = ''
      # This got here thanks to unpackPhase
      cp -r ./Contents/Home $out;
    '';

    # inspired by nixpkgs/pkgs/development/compilers/openjdk/darwin/default.nix
    # not included: jni, jce
    preFixup = ''
      # Propagate the setJavaClassPath setup hook from the JDK so that
      # any package that depends on the JDK has $CLASSPATH set up
      # properly.
      mkdir -p $out/nix-support
      printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

      install_name_tool -change /usr/X11/lib/libfreetype.6.dylib ${freetype}/lib/libfreetype.6.dylib $out/lib/libfontmanager.dylib

      # Set JAVA_HOME automatically.
      cat <<EOF >> $out/nix-support/setup-hook
      if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
      EOF
    '';

    passthru = {
      home = jdk;
      jre = jdk;
    };
  };
in jdk
