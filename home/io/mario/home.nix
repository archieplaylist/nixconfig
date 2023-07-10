{ config, pkgs, inputs, ... }: 
let 
  nixpkgs-f2k = inputs.nixpkgs-f2k;
in
{
  home.username = "mario";
  home.homeDirectory = "/home/mario";

  imports = [
    ../../shared/home.nix
    ./gtk
    ./kitty
    ./unstable.nix
  ];

  home.packages = with pkgs;  [
    btop
    exa
    flameshot
    pfetch
    starship
    xdg-utils
    xdg-user-dirs
  ];

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
