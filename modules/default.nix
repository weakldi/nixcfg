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
    ./networkFileSystems.nix
    ./nvidia.nix
  ];

  config.copyConfig = {
    enable = lib.mkDefault true;
    configPath = ../.;
  };

  config.networkMounts.enable = lib.mkDefault true;
}
