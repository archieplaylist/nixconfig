{ unstable, ... }:

{
  home.packages =  with unstable; [
    libreoffice-fresh
    onlyoffice-bin
    vscode-fhs
  ];

}
