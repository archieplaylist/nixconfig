{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
  };

  home.packages = with pkgs; [
    # firefox
    libsForQt5.plasma-browser-integration
  ];
}
