{
  stdenv,
  lib,
  installShellFiles,
  zlib,
  autoPatchelfHook,
  fetchurl,
  makeWrapper,
  callPackage,
  llvmPackages_18,
  which,
  clang_18,
  libunwind,
  darwin,
}:

let
  pname = "sn-bindgen";
  sources = lib.importJSON ./sources.json;
  inherit (sources) version assets;

  platforms = builtins.attrNames assets;
in
stdenv.mkDerivation {
  inherit pname version;
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook
  ++ lib.optional stdenv.hostPlatform.isDarwin darwin.cctools;
  buildInputs = [
    clang_18
    libunwind
    llvmPackages_18.libclang.lib
    stdenv
    which
    zlib
  ];
  autoPatchelfIgnoreMissingDeps = [ "libclang-17.so.17" ];
  src =
    let
      asset =
        assets."${stdenv.hostPlatform.system}"
          or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/indoorvivants/sn-bindgen/releases/download/v${version}/${asset.asset}";
      sha256 = asset.sha256;
    };
  unpackPhase = ''
    runHook preUnpack
    cp $src sn-bindgen
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 sn-bindgen $out/bin/bindgen
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib
    ln -s ${llvmPackages_18.libclang.lib}/lib/libclang.so $out/lib/libclang-17.so.17
    patchelf --set-rpath "$out/lib:$(patchelf --print-rpath $out/bin/bindgen)" $out/bin/bindgen
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -change /opt/homebrew/opt/llvm@17/lib/libclang.dylib \
      ${llvmPackages_18.libclang.lib}/lib/libclang.dylib \
      $out/bin/bindgen
  ''
  + ''
    wrapProgram $out/bin/bindgen \
      --set LIBCLANG_PATH "${llvmPackages_18.libclang.lib}/lib"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    ($out/bin/bindgen 2>&1 || true) | grep -q "Usage:"
  '';

  meta = {
    homepage = "https://github.com/indoorvivants/sn-bindgen";
    downloadPage = "https://github.com/indoorvivants/sn-bindgen/releases/v${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    description = "Generate Scala Native bindings from C headers";
    mainProgram = "bindgen";
    inherit platforms;
  };

  passthru.updateScript = callPackage ./update.nix { } { inherit platforms pname version; };
}
