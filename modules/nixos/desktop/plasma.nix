{ config, lib, ... }: {
  options.nixos.modules.desktop-plasma = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Plasma 6 desktop environment and display manager settings.";
  };

  config.nixos.modules.desktop-plasma = { ... }: {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager.plasma-login-manager.enable = true;
    };
  };
}
