{
  description = "Nixos config flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils"; # for devshells
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      host-name-pc = "kristian-pc";
      myLib = import ./lib/default.nix {inherit inputs;};
      lib = nixpkgs.lib // home-manager.lib;
    in
  with myLib;{
    nixosConfigurations = {
      pc = mkSystem {
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