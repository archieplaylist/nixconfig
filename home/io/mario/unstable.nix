{ unstable, ... }:

{
  home.packages =  with unstable; [
    beekeeper-studio
    dbeaver
    libreoffice-fresh
    onlyoffice-bin
    postman
    remmina
    vscode-fhs
    wpsoffice
  ];

}
