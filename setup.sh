#!/run/current-system/sw/bin/bash

set -e

cp /etc/nixos/hardware-configuration.nix hosts/hardware-configuration.nix

sudo mv /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.bak
sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak


# sudo nix flake update . --extra-experimental-feature nix-command flake
# sudo nixos-rebuild boot --flake .#io --impure