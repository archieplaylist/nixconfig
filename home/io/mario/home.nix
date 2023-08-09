{ config, pkgs, inputs, ... }: 
{
  home.username = "mario";
  home.homeDirectory = "/home/mario";

  imports = [
    ../../shared/home.nix
    ./gtk
    ./unstable.nix
  ];

  home.packages = with pkgs;  [
    btop
    exa
    pfetch
    starship
    xdg-utils
    xdg-user-dirs
  ];

  home = {
    sessionVariables = {
      EDITOR = "code";
      MOZ_ENABLE_WAYLAND = 1;
    };
  };

  programs = { 
    go.enable = true;
    obs-studio = { 
      enable = true;
      package = pkgs.obs-studio;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.package  = pkgs.adwaita-qt;
    style.name = "adwaita-dark";
  };

  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";
    userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
        };
    };
  };

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
