{
  stdenv,
  lib,
  autoPatchelfHook,
  fetchurl,
  callPackage,
}:

{
  pname,
  owner,
  repo,
  sourcesFile,
  mainProgram ? pname,
  description ? "",
  license ? null,
  installCheckPhase ? null,
  extraNativeBuildInputs ? [ ],
  extraBuildInputs ? [ ],
}:

let
  sources = lib.importJSON sourcesFile;
  inherit (sources) version assets;
  platforms = builtins.attrNames assets;

  githubBinaryUpdate = callPackage ./github-binary-update.nix { };
  sourcesFileRelative = lib.removePrefix (toString ../. + "/") (toString sourcesFile);
in
stdenv.mkDerivation {
  inherit pname version;

  nativeBuildInputs =
    lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook
    ++ extraNativeBuildInputs;

  buildInputs = extraBuildInputs;

  src =
    let
      asset =
        assets."${stdenv.hostPlatform.system}"
          or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${asset.asset}";
      sha256 = asset.sha256;
    };

  unpackPhase = ''
    runHook preUnpack
    cp $src ${mainProgram}
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 ${mainProgram} $out/bin/${mainProgram}
    runHook postInstall
  '';

  doInstallCheck = installCheckPhase != null;
  inherit installCheckPhase;

  meta = {
    homepage = "https://github.com/${owner}/${repo}";
    downloadPage = "https://github.com/${owner}/${repo}/releases/v${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit description mainProgram platforms;
  } // lib.optionalAttrs (license != null) { inherit license; };

  passthru.updateScript = githubBinaryUpdate {
    inherit
      owner
      repo
      platforms
      pname
      version
      ;
    sourcesFile = sourcesFileRelative;
  };
}
