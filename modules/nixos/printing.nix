{ config, lib, ... }: {
  options.nixos.modules.printing = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Printing services, drivers, and Avahi auto-discovery.";
  };

  config.nixos.modules.printing = { pkgs, ... }: {
    services.printing = {
      enable = true;
      drivers = [ pkgs.brlaser pkgs.cups-brother-hll3230cdw pkgs.cups-filters ];
    };
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    services.avahi.openFirewall = true;
  };
}
