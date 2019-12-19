{ pkgs, ... }:

{
  imports = [
    ../../config/home/base-unix.nix
    ../../config/home/base-network.nix
  ];

  home.packages = with pkgs; [
    # Fonts
    fontconfig
    fira-code
  ];

  fonts.fontconfig.enable = true;
}
