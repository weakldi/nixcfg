{ config, lib, ... }: {
  options.nixos.modules.udev-arduino = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Udev rules for Arduino Uno.";
  };

  config.nixos.modules.udev-arduino = { ... }: {
    services.udev.extraRules = ''
      # Arduino Uno
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", MODE="0660", TAG+="uaccess", GROUP="users"
    '';
  };
}
