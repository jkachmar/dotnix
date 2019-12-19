{ pkgs, ... }:

{
  programs = {
    git = {
      enable = true;
      ignores = [
        ".DS_Store"
      ];
      userEmail = "joseph.kachmar@gmail.com";
      userName = "Joe Kachmar";
    };
  };
}
