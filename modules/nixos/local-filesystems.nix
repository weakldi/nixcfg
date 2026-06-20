{ config, lib, ... }: {
  options.nixos.modules.local-filesystems = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Local filesystem mounts and swap devices.";
  };
}
