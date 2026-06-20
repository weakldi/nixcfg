{ config, lib, ... }: {
  options.nixos.modules.udev-pico = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Udev rules and tools for Raspberry Pi Pico development.";
  };

  config.nixos.modules.udev-pico = { pkgs, ... }: {
    services.udev.extraRules = ''
      # Cafe / custom
      SUBSYSTEM=="usb", ATTRS{idVendor}=="cafe", ATTRS{idProduct}=="1234", MODE="0660", TAG+="uaccess", GROUP="users"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="cafe", ATTRS{idProduct}=="1234", MODE="0660", SYMLINK+="usb-ws2812"
      
      # PICO Probe
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", MODE="0666", TAG+="uaccess", GROUP="users"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", MODE="0666", SYMLINK+="pico-probe"
    '';
    services.udev.packages = [ pkgs.picotool ];
  };
}
