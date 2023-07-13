{ unstable, ... }:

{
  home.packages =  with unstable; [
    onlyoffice-bin
  ];

  programs.vscode = {
  enable = true;
  package = unstable.vscode-fhs;
};

}
