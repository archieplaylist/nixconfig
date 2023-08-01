{ pkgs, unstable, config, ... }:
let
  nvchad = with pkgs; callPackage ../../derivations/nvchad.nix { };
in
{
  imports = [
    # ./browser
    # ./nvim
  ];

  home.packages =  [
    # discord
    # betterdiscordctl
    unstable.neovim-unwrapped
    pkgs.gittyup
    pkgs.easyeffects
    pkgs.filezilla
    pkgs.firefox-bin
  ];

  xdg.desktopEntries = {
    # discord = {
    #   name = "Discord";
    #   exec = "discord --enable-gpu-rasterization";
    # };
  };

  programs = {
    tmux = {
      enable = true;
      mouse = true;
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Catppuccin-mocha";
      };
      themes = {
        Catppuccin-mocha = builtins.readFile (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
          hash = "sha256-qMQNJGZImmjrqzy7IiEkY5IhvPAMZpq0W6skLLsng/w=";
        });
      };
    };

    # skim provides a single executable: sk.
    # Basically anywhere you would want to use grep, try sk instead.
    skim = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    git = {
      enable = true;
      # package = pkgs.git;
      userName  = "archplaylist";
      userEmail = "mario.tani25@gmail.com";
  };
  };
}
