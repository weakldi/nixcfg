{ config, lib, ... }: {
  options.nixos.modules.desktop-hyprland = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Hyprland desktop compositor system settings.";
  };

  config.nixos.modules.desktop-hyprland = { ... }: {
    programs.hyprland.enable = true;
  };
}
