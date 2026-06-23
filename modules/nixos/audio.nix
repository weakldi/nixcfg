{ config, lib, ... }: {
  options.nixos.modules.audio = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Audio services and Pipewire/Wireplumber settings.";
  };

  config.nixos.modules.audio = { pkgs, ... }: {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      pipewire
    ];
  };
}
