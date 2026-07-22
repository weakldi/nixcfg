{ config, lib, ... }: {
  options.nixos.modules.desktop-niri = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Niri desktop compositor system settings.";
  };

  config.nixos.modules.desktop-niri = { pkgs, ... }: {
    programs.niri.enable = true;
    programs.waybar.enable = true;
    systemd.user.services.waybar.wantedBy = lib.mkForce [ ];

    environment.systemPackages = with pkgs; [
      fuzzel
      mako
    ];
  };
}
