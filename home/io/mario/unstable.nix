{ unstable, ... }:

{
  home.packages =  with unstable; [
    beekeeper-studio
    dbeaver
    libreoffice-fresh
    mission-center
    onlyoffice-bin
    postman
    remmina
    transmission
    vscode-fhs
    wpsoffice
  ];

}
