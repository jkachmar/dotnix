{ pkgs, ... }:

{
  imports = [ ../../config/home/darwin.nix ];

  home.packages = with pkgs; [
    awscli
  ];
}
