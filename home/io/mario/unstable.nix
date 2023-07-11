{ unstable, ... }:

{
  home.packages =  with unstable; [
    vscode-fhs
    # onlyoffice-bin
  ];

}
