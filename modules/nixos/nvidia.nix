{ config, lib, ... }: {
  options.nixos.modules.nvidia = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Nvidia hardware graphics support.";
  };

  config.nixos.modules.nvidia = { pkgs, config, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.graphics = {
      extraPackages = with pkgs; [
        libva-vdpau-driver
      ];
    };
  };
}
