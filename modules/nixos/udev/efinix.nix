{ config, lib, ... }: {
  options.nixos.modules.udev-efinix = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Udev rules for Efinix USB Programmer.";
  };

  config.nixos.modules.udev-efinix = { ... }: {
    services.udev.extraRules = ''
      # Efinix USB Programmer (FTDI)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="666", TAG+="uaccess", GROUP="plugdev", ENV{ID_MM_DEVICE_IGNORE}="1"
      
      # Wichtig: Auch den TTY-Layer für ModemManager sperren
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", ENV{ID_MM_DEVICE_IGNORE}="1"
    '';
  };
}
