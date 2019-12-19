{ pkgs, ... }:

{
  programs = {
    direnv = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
