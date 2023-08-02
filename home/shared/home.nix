{ pkgs, unstable, config, ... }:
let
  nvchad = with pkgs; callPackage ../../derivations/nvchad.nix { };
in
{
  imports = [
    ./browser
    # ./nvim
  ];

  home.packages =  [
    unstable.neovim-unwrapped
    pkgs.gittyup
    pkgs.easyeffects
    pkgs.filezilla
    # pkgs.firefox-bin
  ];

  xdg.desktopEntries = {
    ##
  };

  programs = {
    git = {
      enable = true;
      userName  = "archplaylist";
      userEmail = "mario.tani25@gmail.com";
    };

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
  };
}
