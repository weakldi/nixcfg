{
  pkgs,
  system,
  inputs,
  config,
  lib,
  myLib,
  home-manager,
  ...
}:

{
    # Let Home Manager install and manage itself.
    
  
    programs.home-manager.enable = true;
    imports = [
      ./hyperland.nix
    ];
}
