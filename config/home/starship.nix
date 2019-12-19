{ pkgs, ... }:

{
  programs = {
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
