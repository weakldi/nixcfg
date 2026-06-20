{ config, lib, ... }: {
  options.nixos.modules.udev-esp32 = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Udev rules for Espressif USB JTAG/serial debug units.";
  };

  config.nixos.modules.udev-esp32 = { ... }: {
    services.udev.extraRules = ''
      # Espressif USB JTAG/serial debug units
      SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", GROUP="plugdev", TAG+="uaccess", GROUP="users"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1002", MODE="0660", GROUP="plugdev", TAG+="uaccess", GROUP="users"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", SYMLINK+="usb-esp32-c6"
    '';
  };
}
