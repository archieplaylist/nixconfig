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

### Note

Dont forget to change user name and hash password on `hosts/shared/default.nix`

```bash
nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
```

# Post Configuration

### [](https://github.com/Spaxly/espresso#installing-nvchad)Installing NvChad

```bash
git clone https://github.com/NvChad/NvChad --depth 1 ~/.config/nvim
```

### If using yuzu appimage ( optional if using KDE or QT base DE )

```bash
nix-shell -p appimage-run
# Then, already inside of the shell
QT_PLUGIN_PATH= appimage-run ./yuzu.appimage
```

# Secure Boot ( Optional )

## Create secureboot directory

```bash
sudo mkdir /etc/secureboot
```

## Verify files are signed for secure boot

```bash
sudo sbctl verify
```

## [](https://github.com/Spaxly/espresso#reboot-enable-secure-boot-and-boot-into-newly-installed-nixos)Reboot, enable secure boot and boot into newly installed NixOS

Enroll secure boot keys

```bash
sudo sbctl enroll-keys --microsoft
```
