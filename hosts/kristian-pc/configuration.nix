# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Flake
  nix.settings.experimental-features = ["nix-command" "flakes"];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kristian-pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
  services.desktopManager.plasma6.enable = true;
  boot.initrd = {
    supportedFilesystems = [ "nfs" ];
    kernelModules = [ "nfs" ];
  };


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
  
  # ============= GPU Acceleraton (in hosts/common) ============

  ## Enable OpenGL
  #hardware.opengl = {
  #  enable = true;
  #  #driSupport = true;
  #  driSupport32Bit = true;
  #};

 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # ========= SOPS =======
  sops.defaultSopsFile = ./secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.generateKey = true;
  sops.age.keyFile = "/home/kristian/.config/sops/age/keys.txt";
  sops.secrets.testValue = {};

  # ======== Nix-helper ========
  programs.nh = {
    enable = true;
  #  clean.enable = true;
  #  clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/kristian/nixcfg";
  };
}
