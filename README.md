# Personal NixOs Config with Flakes

## How to install to your existing NixOS

```bash
git clone https://github.com/archieplaylist/nixconfig.git
cd nixconfig
```

### Copy your hw-config to hosts/hardware-configuration.nix

```bash
cp /etc/harware-configuration.nix hosts/hardware-configuration.nix
```

### NixOS Rebuild

```bash
sudo nixos-rebuild boot --flake .#io --impure
```

### Note :

Dont forget to change user name and hash password on `hosts/shared/default.nix`

```bash
nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
```

# Post Configuration

### [](https://github.com/Spaxly/espresso#installing-nvchad)Installing NvChad

```bash
git clone https://github.com/NvChad/NvChad --depth 1 ~/.config/nvim
```
