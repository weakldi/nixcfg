{ self, inputs, config, lib, ... }: {
  config.flake = {
    # NixOS system configurations
    nixosConfigurations = lib.mapAttrs (name: hostConfig:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          outputs = self.outputs;
        };
        modules = [
          # The host-specific configuration module
          hostConfig

          # Add default overlays
          ({ pkgs, ... }: {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import inputs.nixpkgs-unstable {
                  inherit (pkgs.stdenv.hostPlatform) system;
                  config.allowUnfree = true;
                };
                plecs = self.packages.${final.system}.plecs or null;
              })
              inputs.mcp-nixos.overlays.default
            ];
          })

          # Pre-integrate standard modules (sops-nix) for all hosts
          inputs.sops-nix.nixosModules.sops
        ];
      }
    ) config.nixosConfigurations;
  };
}
