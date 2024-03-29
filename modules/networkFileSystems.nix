{
    lib,
    myLib,
    pkgs,
    config,

    ...
}:
let
  cfg = config.networkMounts;
in
{
    options.networkMounts = {
        enable = lib.mkEnableOption "Enable Systemdunits for automountig nfs drives.";
    };

    config = lib.mkIf cfg.enable {
        boot.initrd = {
            supportedFilesystems = [ "nfs" ];
            kernelModules = [ "nfs" ];
        };

        services.nfs.server.enable = true;
        # make directory for nfs mount
        system.activationScripts.mkdirNFS = ''
            mkdir -p /mnt/nfs/public
            mkdir -p /mnt/nfs/kristian
            '';

        # mount NAS with nfs
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
