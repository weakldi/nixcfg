{ config, pkgs,winboat, ... }:
let
 
  in
{

  #cachix
  #imports = [ ./cachix.nix ];

  # Flake
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.extraOptions = ''
        trusted-users = root kristian
        extra-substituters = https://nixpkgs-python.cachix.org
        extra-trusted-public-keys = nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    # Openconnect plugin
    plugins = [pkgs.networkmanager-openconnect];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # printing
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.brlaser pkgs.cups-brother-hll3230cdw pkgs.cups-filters];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [
          "hsp_hs"
          "hsp_ag"
          "hfp_hf"
          "hfp_ag"
        ];
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm; # Ensures KVM support
      swtpm.enable = true;
     
      vhostUserPackages = [ pkgs.virtiofsd ];
      
      
      # Use this to ensure the virtual machine can access your hardware drivers
      verbatimConfig = ''
        display_sdl = "yes"
        display_gtk = "yes"
      '';
    };
  };
  services.spice-vdagentd.enable = true;

  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  programs.nix-ld.enable = true;
  
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation.docker = {
      enable = true;
		  enableOnBoot = false;
		  

      rootless = {
        enable = false;
        setSocketVariable = true;
      };

      daemon.settings = {
				runtimes = {
					nvidia = {
          	path = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
          };
				};
      };
  };
  # Android
  programs.adb.enable = true;
  programs.java = {
    enable = true;
    package = pkgs.jdk25;
  };
  virtualisation.waydroid = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kristian = {
    isNormalUser = true;
    description = "kristian Minderer";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "libvirtd" "kvm" "dialout" "video" "render" "plugdev"];
    packages = with pkgs; [
      firefox
      thunderbird
      vscode
      mpv
      vlc 
      #jetbrains.clion   
      #jetbrains.pycharm
      #jetbrains.idea
      #jetbrains.datagrip
      devenv
      openems
      mattermost-desktop
      pavucontrol

      # pico
      pico-sdk

      # Database stuff
      #dbeaver-bin
      #mysql84

      opencode
     ];
  };

  users.groups = {
    waydroidApp = {
      gid = 10148;
      members = ["kristian"];
    };
  };
  users.extraGroups.docker.members = ["kristian"];
  # flatpack
  services.flatpak.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  # Verhindert, dass NixOS das vboxnet0-Interface erzwingt (nh os switch funktioniert so nicht)
  virtualisation.virtualbox.host.addNetworkInterface = false; # 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    sl
    git
    kdePackages.kate
    htop
    distrobox
    unzip
    gnutar
    file
    #devenv
    # openconnect vpn for vpn-fh-muenster.de
    openconnect
    #android backup extractor
    #android-backup-extractor
    # waydroid x11
    #weston
    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # support 32-bit only
    #wine

    # support 64-bit only
    #(wine.override { wineBuild = "wine64"; })

    # wine-staging (version with experimental features)
    wineWowPackages.staging

    # winetricks (all versions)
    winetricks
    #ms fonts for wine
    wineWowPackages.fonts
    # native wayland support (unstable)
    wineWowPackages.waylandFull

    #Python
    #python3
    #python3Packages.tensorflowWithCuda
    docker
    virt-manager
    virtiofsd
    gnumake

    nfs-utils
    pkgs.octavePackages.signal

    #sshfs
    sshfs
    # Steam
    steam-run
    steam-tui
    # nix helper
    unstable.nh
    nix-output-monitor
    nvd
    #mono

    # Office
    #softmaker-office
    #onlyoffice-desktopeditors
    #wpsoffice

    nvidia-container-toolkit

    # Hardware / CPU-Fan / Temp
    lm_sensors
    btop

    # Logic analyzer pico
    pulseview
    #arduino-ide

    # mqtt
    mosquitto

    # IDEs
    #netbeans
    #zulu24

    nil # lsp für nix

    # gz
   # ogre
    cmake
    tinyxml-2
    urdfdom
    spdlog
    pkg-config

    #winboat
    freerdp
    docker-compose
    docker
    appimage-run
    gemini-cli
    pulseview
    sigrok-cli

    qucs-s
    ngspice # simulationsbackend für qucs-s
    qucsator-rf
    xyce # xyce-parallel  nur für riesige Schaltungen

    (kicad.override {
      python3 = python3.withPackages (ps: with ps; [ 
        pyclipper 
      ]);
    })
   ];
  
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # ENV for nix-helper
  environment.sessionVariables = {
    #FLAKE = builtins.toString ../.;
  };
  
  # ============= STEAM ==============
  programs.hyprland.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  #============ KDE Connect ==========

  programs.kdeconnect.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.mosquitto = {
    enable = true;
    logType = ["all"];
    listeners = [
      
      {
        port = 1884;
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
        
      }
    ];
   
  };
  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 
      4242 # pico-examples 
      24800 #(barrier kvm maus) 
      1883 # mosquitto normal
      1884 # mosquitto local
      8080 
      8081
      631 # ipp printing
    ]; 
    allowedUDPPorts = [ 1234]; # pi pico udp

    # Allow Gazebo transport ports locally
    allowedTCPPortRanges = [
      { from = 11345; to = 11445; }
    ];
    allowedUDPPortRanges = [
      { from = 11345; to = 11445; }
    ];

  };
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # udev rules for kernel programming
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="cafe", ATTRS{idProduct}=="1234", MODE="0660", TAG+="uaccess", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="cafe", ATTRS{idProduct}=="1234", MODE="0660", SYMLINK+="usb-ws2812"
    
    # PICO Probe
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", MODE="0666", TAG+="uaccess", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", MODE="0666", SYMLINK+="pico-probe"

    # Arduino Uno
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", MODE="0660", TAG+="uaccess", GROUP="users"

    # Espressif USB JTAG/serial debug units
    SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", GROUP="plugdev", TAG+="uaccess", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1002", MODE="0660", GROUP="plugdev", TAG+="uaccess", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", SYMLINK+="usb-esp32-c6"
  
    # Efinix USB Programmer (FTDI)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="666", TAG+="uaccess", GROUP="plugdev", ENV{ID_MM_DEVICE_IGNORE}="1"

    # FTDI other (Fixed the dot here)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="666", TAG+="uaccess", GROUP="plugdev", ENV{ID_MM_DEVICE_IGNORE}="1"

    # FT4232H
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6011", MODE="666", TAG+="uaccess", GROUP="plugdev"

    # FT4232HA
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6048", MODE="666", TAG+="uaccess", GROUP="plugdev"

    # Wichtig: Auch den TTY-Layer für ModemManager sperren
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", ENV{ID_MM_DEVICE_IGNORE}="1"
  '';
  services.udev.packages = [ pkgs.picotool pkgs.libsigrok];



  hardware.graphics = {
    enable = true;
    # for wine (Target 3001) and 32 bit apps
    # 32bit steam games ...
    enable32Bit = true;
  };

}
