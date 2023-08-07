{ config, pkgs, ... }:

{
  imports =
    [
      ../hardware-configuration.nix
      ../shared
      ../shared/fhs-fonts.nix
    ];

#   boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

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

  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [ oxygen ];
  programs.dconf.enable = true;

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

