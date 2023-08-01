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
    # boot.kernelPackages = pkgs.linuxPackages_latest;

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
      gdm = {
        enable = true;
      };
      # defaultSession = "gnome";
    };
    desktopManager = { 
      gnome.enable = true; 
      };
  };

  # GPU DRIVER
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = 
    ''
      Option "DRI" "2"
      Option "TearFree" "True"
    '';


  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.gnome.games.enable = false;
  services.gnome.gnome-keyring ={
    enable = true;
  };

  programs.seahorse = {
    enable = true;
  };

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
    gnomeExtensions.removable-drive-menu
    gnomeExtensions.blur-my-shell
    gnomeExtensions.vitals
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.appindicator
    gnomeExtensions.coverflow-alt-tab
    gnomeExtensions.gsconnect
  ];

  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };

  environment.variables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "code";
    # QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  system.stateVersion = "23.05";
}

