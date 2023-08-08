{ pkgs, config, lib, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    iconTheme = {
      name = "Adwaita";
      # package = pkgs.papirus-icon-theme;
    };
    gtk3.bookmarks = [ 
      "file:///mnt/datafile"
      "smb://192.168.1.225/master/ master on 192.168.1.225"
      "smb://192.168.1.225/backup/ backup on 192.168.1.225"
      "smb://file3-svr.rkzsby.local/rskdoc R"
      "smb://file-svr.rkzsby.local/rsk_f G"
      ];
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # gtk-theme = "Catppuccin-Mocha-Standard-Blue-Dark";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "CoverflowAltTab@palatis.blogspot.com"
        "Vitals@CoreCoding.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
        "clipboard-indicator@tudmotu.com"
        "dash-to-dock@micxgx.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "gTile@vibou"
      ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
    };
  };
     

  home.sessionVariables = {
    GTK_THEME = "Catppuccin-Mocha-Standard-Blue-Dark";
  };
}
