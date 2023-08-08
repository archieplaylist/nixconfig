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
#   boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable the X11 and Wayland windowing system.
  services.xserver = {
    enable = true;

    # TOUCHPAD
    libinput = {
      enable = true;
      touchpad.tapping = true;
    };

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

  services.gnome.gnome-keyring ={
    enable = true;
  };

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [ oxygen ];

  programs.dconf.enable = true;

  # GPU DRIVER
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = 
    ''
      Option "DRI" "2"
      Option "TearFree" "True"
    '';

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "code";
  };

  system.stateVersion = "23.05";
}

