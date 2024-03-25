# Nixos Konfiguration

## Dateistruktur

1. home: Homemanager home.nix für die unterschiedlichen Nutzer.
2. homemodules: Eigene Module für Homemanager.
3. hosts: Systemkonfigurationen für die Computer
4. lib: Eigene Funktionen
5. modules: Eigene Module für die Systemkonfigurationen
6. packages: Eigene Pakete

## Installation

Nutzer und host durch gewünschten Nutzer / Host ersetzten.
```sh
nix develop
nixos-rebuild switch --flake ./#host
home-manager switch --flake ./#nutzer
```

## Nützlich Befhele:

1. Systemgennerationen aufzählen:
   `nix-env --list-generations --profile /nix/var/nix/profiles/system`

2. Homemanager Gennerationen aufzählen:
   `nix-env --list-generations`


