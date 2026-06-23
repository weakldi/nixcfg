{ self, inputs, ... }: {
  systems = [ "x86_64-linux" ];

  perSystem = { pkgs, system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    packages = import ../../packages { inherit pkgs; };
  };
}
