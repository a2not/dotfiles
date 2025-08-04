{pkgs, ...}: {
  home.packages = with pkgs; [
    delta
  ];

  programs.git = {
    enable = true;
    includes = [
      {
        path = "./.gitconfig";
      }
      {
        path = "./.gitconfig_work";
        condition = "gitdir:~/go/src/github.sakura.codes";
      }
    ];
  };
}
