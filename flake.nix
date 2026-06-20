{
  description = "Restructured NixOS configuration using Dendritic pattern";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree = {
      url = "github:vic/import-tree";
      flake = false;
    };

    mcp-nixos = {
      url = "github:utensils/mcp-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    evaluation = inputs.flake-parts.lib.evalFlakeModule { inherit inputs; } {
      imports = [
        # Automatically import all .nix files under the modules/ directory recursively
        (import inputs.import-tree ./modules)
      ];
    };
  in
    evaluation.config.flake;
}
