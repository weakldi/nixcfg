{
    lib,
    myLib,
    pkgs,
    config,

    ...
}:

{
    imports = [
        inputs.sops-nix.nixosModules.sops
    ];

    options = {
        enable = lib.mkEnableOption;
        
    }

}