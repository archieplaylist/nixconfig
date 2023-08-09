#!/run/current-system/sw/bin/bash

set -e

cp /etc/nixos/harware-configuration.nix hosts/hardware-configuration.nix

mv /etc/nixos/harware-configuration.nix /etc/nixos/harware-configuration.nix.bak
mv /etc/nixos/configuration.nix /etc/nixos/configuration.nix.bak


sudo nix flake update .
# sudo nixos-rebuild boot --flake .#io --impure