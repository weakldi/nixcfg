{ config, lib, ... }: {
  options.nixos.modules.docker = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Docker daemon, rootless configurations, and Nvidia GPU container runtime support.";
  };

  config.nixos.modules.docker = { pkgs, ... }: {
    hardware.nvidia-container-toolkit.enable = true;
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      rootless = {
        enable = false;
        setSocketVariable = true;
      };
      daemon.settings = {
        runtimes = {
          nvidia = {
            path = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
          };
        };
      };
    };
    users.extraGroups.docker.members = [ "kristian" ];
  };
}
