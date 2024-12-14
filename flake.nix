{
  description = "Nixos config flake";

  inputs = {

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils"; # for devshells
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, nixpkgs-unstable, ... }@inputs:
    let
      system = "x86_64-linux";
      host-name-pc = "kristian-pc";
      myLib = import ./lib/default.nix {inherit inputs;};
      lib = nixpkgs.lib // home-manager.lib;
    in
  with myLib;{
    nixosConfigurations = {
      kristian-pc = mkSystem {
          sys = system;
          config = ./hosts/kristian-pc/configuration.nix;
        };
    };
   
    homeConfigurations = {
      "kristian" = mkHome system ./home/kristian.nix;
    };

    homeManagerModules.default = ./homemodules;
    nixosModules.default = ./modules;

    # ========= Shells =========
    #devShells."${system}" = let
    #  pkgs = import nixpkgs {
    #    inherit system;
    #    config.allowUnfree = true;
    #  };
    #in  import ./shell.nix  {inherit pkgs;};
  
    devShells = myLib.mkDevShell [system] ./shell.nix;
  };
}
