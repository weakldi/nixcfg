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
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  config.copyConfig = {
    enable = lib.mkDefault true;
    configPath = ../.;
  };

  config.networkMounts.enable = lib.mkDefault true;
}
