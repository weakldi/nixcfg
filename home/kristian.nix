{ inputs, outputs, lib, pkgs, home-manager, nixpkgs,... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      dvisvgm dvipng # for preview and export as html
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
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });

  python_packages = ps : with ps; [
    nltk
    pyusb
    jupyter
    ipython
    ipywidgets
    ipympl
    pandas
    chart-studio

    numpy
    numdifftools
    matplotlib
    scipy
    spyder-kernels
    jupyterlab
    conda

    torch-bin
    torchvision-bin
    tensorflow
    keras

    paho-mqtt
  ];
  
  spyder-custom = pkgs: pkgs.spyder.overrideAttrs (oldAttrs: {
        buildInputs = oldAttrs.buildInputs ++ [
            pkgs.python3  # Oder eine andere Python-Version
            pkgs.python3Packages.spyder-kernels
            pkgs.python3Packages.jupyter
            
        ];
        propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [] ++ [
            pkgs.python3Packages.spyder-kernels
            pkgs.python3Packages.jupyter
        ];
    }

  );
  octave_pkgs = opkgs: with opkgs; [signal];
in
{
  imports = [outputs.homeManagerModules.default];
  programs.home-manager.enable = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.


  home.username = "kristian";
  home.homeDirectory = "/home/kristian";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    #pkgs.octaveFull
    tex
    pkgs.keepassxc
    pkgs.owncloud-client
    # libreoffice
    pkgs.libreoffice-qt
    #spellcheck for libreoffice
    pkgs.hunspell
    pkgs.hunspellDicts.de_DE
   
    #pipewire audio graph
    pkgs.qpwgraph
    # octave Signalprocessing
    (pkgs.octaveFull.withPackages octave_pkgs)

    pkgs.eclipses.eclipse-cpp
    pkgs.gcc
    pkgs.logisim-evolution
    pkgs.sops
    pkgs.prismlauncher

    pkgs.kicad
    
    #pkgs.blender_3_6

    pkgs.zoom-us

    pkgs.texstudio
    pkgs.texmaker
    (pkgs.python3.withPackages python_packages)
    pkgs.nodejs # für jupyter-lab
    #(spyder-custom pkgs)

    pkgs.spyder

    pkgs.remmina
    
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kristian/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  
}
