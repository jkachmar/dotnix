{ pkgs, ... }:

{
  imports = [ ./nixos.nix ];

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      emacs-all-the-icons-fonts
      hack-font
      fira-code
    ];
  };
}
