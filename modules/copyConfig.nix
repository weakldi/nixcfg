{
    lib,
    myLib,
    pkgs,
    config,

    ...
}:
with lib;
let
    # Shorthand for the config
    cfg = config.copyConfig;

    # Package
    cpCfg = (pkgs.callPackage ../packages/cpCfg.nix { configFolder = cfg.configPath; isGit = false; inherit lib;});

    # Files in /etc to gennerate
    etcFileList = (lib.forEach cpCfg.fileList (file:
        "current-config" + builtins.substring ((builtins.stringLength (toString cfg.configPath))) (-1) (toString file)
    ));

in
{
    options.copyConfig = {
        enable = mkEnableOption "Copy Congig file in nixstore.";
        configPath = mkOption{
            type = types.path;
            default = ../.;
        };


    };
    #mkIf cfg.enable
    config = mkIf cfg.enable {
        environment.systemPackages = [
            cpCfg
        ];

        # Gennerate files in /etc
        environment.etc = genAttrs etcFileList (path: {source = "${cpCfg}/etc/" + path;});

    };
}
