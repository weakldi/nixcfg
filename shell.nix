# from https://github.com/Misterio77/nix-config/blob/main/shell.nix

{ pkgs ? # If pkgs is not defined, instanciate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
  import nixpkgs { overlays = [ ]; }
, ...
}: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      sops
      ssh-to-age
      #gnupg
      age
    ];

    shellHook = ''
      echo Create system with
      echo 1. nixos-rebuild switch --flake ./#pc
      echo 2. home-manager switch --flake ./#kristian
    '';
  };

  mc-example-shell = pkgs.mkShell {
    name = "test-Shell";

    nativeBuildInputs = with pkgs; [
        minecraft
    ];
  };

  qt-shell =   pkgs.mkShell {
    buildInputs = with pkgs; [
        cmake
        gdb
        qt6.full
        qt6.qtbase
        qtcreator

        # this is for the shellhook portion
        qt6.wrapQtAppsHook
        makeWrapper
        bashInteractive
      ];
      # set the environment variables that Qt apps expect
      shellHook = ''
        bashdir=$(mktemp -d)
        makeWrapper "$(type -p bash)" "$bashdir/bash" "''${qtWrapperArgs[@]}"
        exec "$bashdir/bash"
      '';
  };

  pico-shell = let
        pico-sdk-151-tinyusb = with pkgs; (pico-sdk.overrideAttrs (o:
              rec {
              pname = "pico-sdk";
              version = "1.5.1";
              src = fetchFromGitHub {
                fetchSubmodules = true;
                owner = "raspberrypi";
                repo = pname;
                rev = version;
                 sha256 = "sha256-GY5jjJzaENL3ftuU5KpEZAmEZgyFRtLwGVg3W1e/4Ho=";#lib.fakeSha256;
              };
        }));
      in

    pkgs.mkShell {
      # Set the shell name
      name = "pico-sdk-shell";

      # Declare dependencies
      buildInputs = with pkgs; [
        cmake
        git
        gcc-arm-embedded
        pico-sdk
        pico-sdk-151-tinyusb
      ];

      # Fetch and build the Pico SDK
      shellHook = ''
        export PICO_SDK_PATH_NORMAL="${pkgs.pico-sdk}/lib/pico-sdk"
        export PICO_SDK_PATH="${pico-sdk-151-tinyusb}/lib/pico-sdk"
      '';
    };
}
  
