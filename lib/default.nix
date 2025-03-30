# "inspiriert" von https://github.com/vimjoyer/nixconf/
{inputs}:
let
 myLib = (import ./default.nix) {inherit inputs;};
 outputs = inputs.self.outputs;

 

in rec{
    lib = inputs.nixpkgs.lib;
    #====== Dir and file functions =======

    # Funktion makes path relativ
    # [path] -> [path] -> string
    # Prüft nicht ob root in path ist!
    relPathStr = root: path: let
        rootStr = toString root;
        pathStr = toString path;
        rootLen = builtins.stringLength rootStr;
        pathLen = builtins.stringLength pathStr;
    in
        if (rootLen <= pathLen) then
            (builtins.substring (rootLen + 1) pathLen pathStr)
        else
            throw "RootPaht is longer than relativ Path";

    attribute = name: value: {"${name}" = value;};
    # ============ pkg functions =========
    pkgsUnstable = sys: import inputs.nixpkgs-unstable {
        system = sys;
        config.allowUnfree = true;
    };
    # Function: (System [String]) -> pkgs
    pkgsFor = sys: import inputs.nixpkgs {
        system = sys;
        config.allowUnfree = true;
        overlays = [
            inputs.blender.overlays.default
            (import ../overlays/spyder-overlay.nix)
        ];
    };

    overlay-unstable = sys: prev: final: {
        unstable = pkgsUnstable sys;
    };

    # Function to define a Nixosconfig
    # sys: Systemstring bsp.: x86_64-linux
    # config: Path to configfile
    mkSystem = {sys, config}:
        inputs.nixpkgs.lib.nixosSystem {
            system = sys; # to be repaced with argument
            specialArgs = {
                inherit inputs outputs myLib;
            };
            modules = [
                ({config, pkgs, ...}: {nixpkgs.overlays = [(overlay-unstable sys)];})
                ../hosts/common.nix
                config
                outputs.nixosModules.default # ???

            ];
        };

    # Function to define a Homeconfig
    # sys: Systemstring bsp.: x86_64-linux
    # config: Path to configfile
    mkHome = sys: config: 
        inputs.home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
                inherit inputs myLib outputs;
            };
            pkgs = pkgsFor sys;
            modules = [
                config
                outputs.homeManagerModules.default
            ];
        };

    # Function to define a mkDevShell
    # Systems: list of Systemstrings
    # shellFile: path to shell.nix (can define multiple shells)
    #   => Outputs {
    #                   defualt = {...} # First shell
    #                   example = {...} # second shell
    #              }
    # ShellFile must contain a function: pkgs -> {shell1; shell2; ...; shellN}
    # shell1, ..., shellN are the names of the shells
    mkDevShell = systems: shellFile:
        inputs.nixpkgs.lib.genAttrs systems (system: let # Map shell list to attrbutes [sys1 sys2] -> {sys1 = {shells}; sys2 = {shells}}
                pkgs = pkgsFor system; # gen Packets
            in import shellFile {inherit pkgs;} # import shell
        )
    ;
}
