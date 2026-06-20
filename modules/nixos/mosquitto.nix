{ config, lib, ... }: {
  options.nixos.modules.mosquitto = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Mosquitto MQTT broker configuration.";
  };

  config.nixos.modules.mosquitto = { ... }: {
    services.mosquitto = {
      enable = true;
      logType = [ "all" ];
      listeners = [
        {
          port = 1884;
          acl = [ "pattern readwrite #" ];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };
  };
}
