{ config, pkgs, ... }:

{
  #cachix
  #imports = [ ./cachix.nix ];

  # Flake
  nix.settings.experimental-features = ["nix-command" "flakes"];

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
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # printing
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.cups-brother-hll3230cdw ];
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true; # virt-manager requires dconf to remember settings

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = false;
    setSocketVariable = true;
  };
  # Android
  programs.adb.enable = true;

  virtualisation.waydroid = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kristian = {
    isNormalUser = true;
    description = "kristian Minderer";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" "libvirtd"];
    packages = with pkgs; [
      firefox
      thunderbird
      vscode
      mpv
      vlc
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


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #(callPackage ./cpCfg.nix { configFolder = ./.; isGit = false;})
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    sl
    git
    libsForQt5.kate
    htop
    distrobox
    unzip
    gnutar
    file
    # openconnect vpn for vpn-fh-muenster.de
    openconnect
    #android backup extractor
    android-backup-extractor
    # waydroid x11
    weston
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
    python3
    #python3Packages.tensorflowWithCuda
    docker
    virt-manager
    gnumake

    nfs-utils
    pkgs.octavePackages.signal

    #sshfs
    sshfs
   ];

  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };
  # for wine (Target 3001) and 32 bit apps
  hardware.opengl.driSupport32Bit = true;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # udev rules for kernel programming
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="cafe", ATTRS{idProduct}=="1234", MODE="0660", TAG+="uaccess", GROUP="1000",OWNER="1000"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="cafe", ATTRS{idProduct}=="1234", MODE="0660", SYMLINK+="usb-ws2812"

    # Arduino Uno
    SUBSYSTEM=="tty", ATTRS{idVendor}=="2341", ATTRS{idProduct}=="0043", MODE="0660", TAG+="uaccess", GROUP="1000",OWNER="1000"
  '';

  services.nfs.server.enable = true;
  # make directory for nfs mount
  system.activationScripts.mkdirNFS = ''
    mkdir -p /mnt/nfs/public
    mkdir -p /mnt/nfs/kristian
  '';

  # mount NAS with nfs
  fileSystems."/mnt/nfs/public" = {
    device = "192.168.178.40:/nfs/Public";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  fileSystems."/mnt/nfs/kristian" = {
    device = "192.168.178.40:/nfs/kristian";
    fsType = "nfs";
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=600"
    ];
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      #intel-media-driver # LIBVA_DRIVER_NAME=iHD
      #vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}