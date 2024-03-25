{
  stdenv,
  lib,
  configFolder,
  isGit,
  ...
}:
let
  source = if isGit then (builtins.fetchGit { url =  configFolder; ref = "HEAD";}) else configFolder;
in stdenv.mkDerivation {
      name = "cpCfg";
      pname = "cpCfg";
      src = source;
      phases = [ "unpackPhase" "installPhase" ];
      outputs = ["out"];
      installPhase = ''
        mkdir -p $out/etc/current-config
        cp -r $src/* $out/etc/current-config
        mkdir -p $out/bin
        echo "echo $out/etc/current-config" >> $out/bin/cfg
      '';
      fileList = lib.filesystem.listFilesRecursive source;
    }
