{ lib, ... }: {
  options = {
    nixosConfigurations = lib.mkOption {
      type = lib.types.attrsOf lib.types.deferredModule;
      default = {};
      description = "NixOS system configurations.";
    };
  };
}
