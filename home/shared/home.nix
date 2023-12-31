{ pkgs, unstable, config, ... }:
let
  nvchad = with pkgs; callPackage ../../derivations/nvchad.nix { };
in
{
  imports = [
    # ./browser
    ./nvim
  ];

  home.packages =  [
    pkgs.discord
    pkgs.youtube-music
    pkgs.betterdiscordctl
    unstable.neovim-unwrapped
  ];

  xdg.desktopEntries = {
    discord = {
      name = "Discord";
      exec = "discord --enable-gpu-rasterization";
    };
  };

  programs = {
    git = {
      enable = true;
      userName  = "archieplaylist";
      userEmail = "mario.tani25@gmail.com";
    };
    
    # A terminal multiplexer
    # tmux = {
    #   enable = true;
    # };

    # a cat(1) clone with syntax highlighting and Git integration.
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
    };
  };
}
