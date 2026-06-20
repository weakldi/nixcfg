{ config, lib, ... }: {
  options.nixos.modules.desktop = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Core desktop/graphical settings (locale, keymaps, timezone, and graphics rendering).";
  };

  config.nixos.modules.desktop = { ... }: {
    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "de";

    # Enable hardware graphics rendering (OpenGL/Vulkan)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
