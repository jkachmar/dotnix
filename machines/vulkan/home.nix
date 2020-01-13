{ pkgs, ... }:

{
  imports = [
    ../../config/home/common.nix
    ../../config/home/darwin.nix
  ];

  home.packages = with pkgs; [
    awscli
  ];
}
