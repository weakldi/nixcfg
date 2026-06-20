{ config, lib, ... }: {
  options.nixos.modules.virtualisation = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Libvirtd/QEMU, Waydroid, and VirtualBox virtualization settings.";
  };

  config.nixos.modules.virtualisation = { pkgs, ... }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
        verbatimConfig = ''
          display_sdl = "yes"
          display_gtk = "yes"
        '';
      };
    };
    services.spice-vdagentd.enable = true;
    programs.dconf.enable = true; # virt-manager requires dconf

    virtualisation.waydroid.enable = true;
    users.groups.waydroidApp = {
      gid = 10148;
      members = [ "kristian" ];
    };

    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
      addNetworkInterface = false; # prevents forcing vboxnet0 interface
    };
  };
}
