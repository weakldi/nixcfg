{ config, lib, ... }: {
  options.nixos.modules.users.kristian = lib.mkOption {
    type = lib.types.deferredModule;
    description = "User account and package configurations for kristian.";
  };

  config.nixos.modules.users.kristian = { pkgs, ... }: let
    tex = (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-full
        dvisvgm dvipng
        wrapfig
        amsmath
        ulem
        hyperref
        capt-of
        circuitikz
        csvsimple
        subfig
        float
        graphics
        sidecap
        mathtools
        extarrows
        xstring
        ;
    });

    python_packages = ps : with ps; [
      pip
      pybind11
      psutil
      pytest
      nltk
      pyusb
      jupyter
      ipython
      ipywidgets
      ipympl
      pandas
      numpy
      numdifftools
      matplotlib
      sympy
      scipy
      sounddevice
      paho-mqtt
    ];

    myPython = pkgs.python3.override {
      packageOverrides = self: super: {
        paho-mqtt = super.paho-mqtt.overridePythonAttrs (oldAttrs: {
          doCheck = false;
        });
      };
    };

    octave_pkgs = opkgs: with opkgs; [signal];
  in {
    # User Account Configuration
    users.users.kristian = {
      isNormalUser = true;
      description = "kristian Minderer";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "adbusers"
        "libvirtd"
        "kvm"
        "dialout"
        "video"
        "render"
        "plugdev"
      ];
      packages = [
        tex
        pkgs.keepassxc
        pkgs.owncloud-client
        pkgs.libreoffice-qt
        pkgs.hunspell
        pkgs.hunspellDicts.de_DE
        pkgs.qpwgraph
        (pkgs.octaveFull.withPackages octave_pkgs)
        pkgs.eclipses.eclipse-cpp
        pkgs.gcc
        pkgs.logisim-evolution
        pkgs.sops
        pkgs.prismlauncher
        pkgs.zoom-us
        pkgs.texstudio
        pkgs.texmaker
        (myPython.withPackages python_packages)
        pkgs.nodejs
        pkgs.appcsxcad
        pkgs.hyp2mat
        pkgs.vscode

        pkgs.firefox
        pkgs.thunderbird


        pkgs.ltspice
      ];
    };
  };
}
