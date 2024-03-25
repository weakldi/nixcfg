{
  pkgs,
  system,
  inputs,
  config,
  lib,
  myLib,
  ...
}:

{
  imports = [
    ./copyConfig.nix
  ];

  config.copyConfig = {
    enable = true;
    configPath = ../.;
  };
}
