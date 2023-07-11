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
      gdm = {
        enable = true;
      };
      # defaultSession = "plasmawayland";
    };
    desktopManager = { 
      gnome.enable = true; 
      };
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = (with pkgs; [
      gnome-tour
  ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gedit # text editor
      epiphany # web browser
      geary # email reader
      gnome-characters
  ]);

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.adwaita-icon-theme
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
  ];

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };

  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "nvim";
  };

  system.stateVersion = "23.05";

}

