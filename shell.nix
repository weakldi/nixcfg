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

      #sops
      #ssh-to-age
      #gnupg
      #age
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
}
