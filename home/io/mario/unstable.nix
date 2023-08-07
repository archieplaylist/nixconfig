{ unstable, ... }:

{
  home.packages =  with unstable; [
    libreoffice-fresh
    onlyoffice-bin
    wpsoffice
  ];

  programs.vscode = {
    enable = true;
    package = unstable.vscode-fhs;
};

}
