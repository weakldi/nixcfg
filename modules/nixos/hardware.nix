{ config, lib, ... }: {
  options.nixos.modules.hardware = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Hardware features (sensors, fans, coolercontrol, kernel parameters).";
  };

  config.nixos.modules.hardware = { ... }: {
    boot.kernelParams = [ "acpi_enforce_resources=lax" ];
    boot.kernelModules = [ "nct6775" "asus_ec_sensors" ];
    programs.coolercontrol.enable = true;
  };
}
