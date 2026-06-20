{ config, lib, ... }: {
  options.nixos.modules.network-filesystems = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Network file systems support (NFS).";
  };

  config.nixos.modules.network-filesystems = { pkgs, ... }: {
    boot.initrd = {
      supportedFilesystems = [ "nfs" ];
      kernelModules = [ "nfs" ];
    };

    services.nfs.server.enable = true;

    system.activationScripts.mkdirNFS = ''
      mkdir -p /mnt/nfs/public
      mkdir -p /mnt/nfs/kristian
    '';

    fileSystems."/mnt/nfs/public" = {
      device = "192.168.178.40:/nfs/Public";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };

    fileSystems."/mnt/nfs/kristian" = {
      device = "192.168.178.40:/nfs/kristian";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };
  };
}
