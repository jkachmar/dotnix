{ pkgs, ... }:

{
  imports = [
    ../../config/home/common.nix
    ../../config/home/darwin.nix
  ];

  home.packages = with pkgs; [
    # Fonts
    fontconfig
    fira-code
  ];

  fonts.fontconfig.enable = true;
}
