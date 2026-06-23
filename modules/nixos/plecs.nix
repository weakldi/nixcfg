{ config, lib, ... }: {
  options.nixos.modules.plecs = lib.mkOption {
    type = lib.types.deferredModule;
    description = "PLECS simulation software package.";
  };

  config.nixos.modules.plecs = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.plecs
    ];

    # Optional: If you want to load the license from a custom path (e.g. inside ~/.config/plecs/license.lic),
    # you can uncomment the session variables below. Otherwise, PLECS will look for license files
    # in `~/.local/share/Plexim/PLECS/licenses/` by default.
    # environment.sessionVariables = {
    #   PLEXIM_LICENSE_FILE = "$HOME/.config/plecs/license.lic";
    # };
  };
}
