#!/run/current-system/sw/bin/bash

set -e

sudo mkdir /etc/secureboot

cp /etc/nixos/harware-configuration.nix hosts/hardware-configuration.nix

mv /etc/nixos/harware-configuration.nix /etc/nixos/harware-configuration.nix.bak
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak


sudo nixos-rebuild boot --flake .#io --impure

sudo sbctl verify
