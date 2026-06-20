{ config, lib, ... }: {
  options.nixos.modules.udev-ftdi = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Udev rules and tools for FTDI / Sigrok development.";
  };

  config.nixos.modules.udev-ftdi = { pkgs, ... }: {
    services.udev.extraRules = ''
      # FTDI other
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="666", TAG+="uaccess", GROUP="plugdev", ENV{ID_MM_DEVICE_IGNORE}="1"

      # FT4232H
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="666", TAG+="uaccess", GROUP="plugdev"

      # FT4232HA
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6048", MODE="666", TAG+="uaccess", GROUP="plugdev"
    '';
    services.udev.packages = [ pkgs.libsigrok ];
  };
}
