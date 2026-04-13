{
  stdenv,
  lib,
  installShellFiles,
  zlib,
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
  githubBinaryPackage = callPackage ../../lib/github-binary-package.nix { };
in
(githubBinaryPackage {
  pname = "sn-bindgen";
  owner = "indoorvivants";
  repo = "sn-bindgen";
  sourcesFile = ./sources.json;
  mainProgram = "bindgen";
  description = "Generate Scala Native bindings from C headers";
  license = lib.licenses.asl20;
  extraNativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin darwin.cctools;
  extraBuildInputs = [
    clang_18
    libunwind
    llvmPackages_18.libclang.lib
    stdenv
    which
    zlib
  ];
  installCheckPhase = ''
    ($out/bin/bindgen 2>&1 || true) | grep -q "Usage:"
  '';
}).overrideAttrs
  (old: {
    autoPatchelfIgnoreMissingDeps = [ "libclang-17.so.17" ];

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
  })
