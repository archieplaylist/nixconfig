{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ../hardware-configuration.nix
      ../shared
      ../shared/fhs-fonts.nix
    ];

#   boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  networking.hostName = "nixdev"; # Define your hostname.

  # Enable the X11 and Wayland windowing system.
  services.xserver = {
    enable = true;

    # TOUCHPAD
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };

    # GPU DRIVER
#     videoDrivers = [ "amdgpu-pro" ];
#     deviceSection = ''
#       Option "DRI" "2"
#       Option "TearFree" "True"
#       '';
#
    # DESKTOP ENVIRONTMENT
    displayManager = {
      sddm = {
        enable = true;
      };
      defaultSession = "plasmawayland";
    };
    desktopManager = { 
      plasma5.enable = true; 
      };
  };

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [ oxygen ];
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "nvim";
  };

  system.stateVersion = "23.05";

}

