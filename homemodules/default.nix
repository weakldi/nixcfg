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
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    imports = [
      ./hyperland.nix
    ];
}
