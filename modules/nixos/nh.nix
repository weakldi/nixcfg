{ config, lib, ... }: {
  options.nixos.modules.nh = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Nix helper mit clean aktiv";
  };
  

  config.nixos.modules.nh = {pkgs, ...} :{
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3 --optimise";
      flake = "/home/kristian/nixcfg/";
    };

    environment.systemPackages = with pkgs; [
        nh
    ];
  };
  
}