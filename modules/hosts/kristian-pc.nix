{ config, lib, pkgs, ... }: {
  # Define local filesystems at the flake level for this host
  config.nixos.modules.local-filesystems = { ... }: {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/e8a22ed9-27fb-41b2-800b-c79f12f8e06e";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/5511-FDB4";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/e4b19f92-a27e-4324-b84e-4380c6cc148c"; }
    ];
  };

  config.nixosConfigurations.kristian-pc = { pkgs, ... }: {
    imports = [
      ../../hosts/kristian-pc/hardware-configuration.nix
      
      config.nixos.modules.users.kristian
      config.nixos.modules.nvidia
      config.nixos.modules.sops
      config.nixos.modules.network-filesystems
      config.nixos.modules.local-filesystems
      config.nixos.modules.udev-all
      
      # Aspect modules
      config.nixos.modules.audio
      config.nixos.modules.printing
      config.nixos.modules.docker
      config.nixos.modules.virtualisation
      config.nixos.modules.mosquitto
      config.nixos.modules.firewall
      config.nixos.modules.hardware
      config.nixos.modules.desktop
      config.nixos.modules.desktop-plasma
    ];

    # Host-specific basic settings
    networking.hostName = "kristian-pc";
    system.stateVersion = "26.05";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Secrets management sops paths
    sops.defaultSopsFile = ../../hosts/kristian-pc/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.secrets.testValue = {};

    # Nix Helper (nh)
    programs.nh = {
      enable = true;
      flake = "/home/kristian/nixcfg-dendritic/";
    };

    # Nix experimental features and settings
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.extraOptions = ''
      trusted-users = root kristian
      extra-substituters = https://nixpkgs-python.cachix.org
      extra-trusted-public-keys = nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';

    # Networking
    networking.networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openconnect ];
    };

    # Flatpak
    services.flatpak.enable = true;

    # Unfree software configuration
    nixpkgs.config.allowUnfree = true;

    # Java Development
    programs.java = {
      enable = true;
      package = pkgs.jdk25;
    };

    # System Packages
    environment.systemPackages = with pkgs; [
      vim
      wget
      sl
      git
      kdePackages.kate
      htop
      distrobox
      unzip
      gnutar
      file
      openconnect
      wineWow64Packages.waylandFull
      winetricks
      wineWow64Packages.fonts
      docker
      virt-manager
      virtiofsd
      gnumake
      nfs-utils
      pkgs.octavePackages.signal
      sshfs
      steam-run
      steam-tui
      nix-output-monitor
      nvd
      nvidia-container-toolkit
      lm_sensors
      btop
      pulseview
      mosquitto
      nil
      cmake
      tinyxml-2
      urdfdom
      spdlog
      pkg-config
      freerdp
      docker-compose
      appimage-run
      gemini-cli
      sigrok-cli
      qucs-s
      ngspice
      qucsator-rf
      xyce
      kicad

      pkgs.mcp-nixos
    ];

    # AppImage Support
    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    # Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    # KDE Connect
    programs.kdeconnect.enable = true;
  };
}
