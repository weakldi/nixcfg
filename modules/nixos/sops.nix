{ config, lib, ... }: {
  options.nixos.modules.sops = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Sops secret management options.";
  };

  config.nixos.modules.sops = { ... }: {
    sops.age.generateKey = true;
    sops.age.keyFile = "/home/kristian/.config/sops/age/keys.txt";
  };
}
