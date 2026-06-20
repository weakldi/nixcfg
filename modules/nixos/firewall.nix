{ config, lib, ... }: {
  options.nixos.modules.firewall = lib.mkOption {
    type = lib.types.deferredModule;
    description = "System network firewall rules and port permissions.";
  };

  config.nixos.modules.firewall = { ... }: {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        4242  # pico-examples
        24800 # barrier kvm mouse
        1883  # mosquitto normal
        1884  # mosquitto local
        8080
        8081
        631   # ipp printing
      ];
      allowedUDPPorts = [ 1234 ]; # pi pico udp
      allowedTCPPortRanges = [
        { from = 11345; to = 11445; } # Gazebo local transport
      ];
      allowedUDPPortRanges = [
        { from = 11345; to = 11445; } # Gazebo local transport
      ];
    };
  };
}
