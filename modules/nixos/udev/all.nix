{ config, lib, ... }: {
  options.nixos.modules.udev-all = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Bundle containing all custom hardware udev rules.";
  };

  config.nixos.modules.udev-all = {
    imports = [
      config.nixos.modules.udev-pico
      config.nixos.modules.udev-arduino
      config.nixos.modules.udev-esp32
      config.nixos.modules.udev-efinix
      config.nixos.modules.udev-ftdi
    ];
  };
}
