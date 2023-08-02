{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "exa -l -i";
      grep = "grep --color";
      sgrep = "grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} ";
      switch = "doas nixos-rebuild switch --flake .#io --impure";
      boot = "doas nixos-rebuild boot --flake .#io --impure";
    };
  };

 # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };
}
