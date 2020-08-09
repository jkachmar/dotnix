let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-darwin {};
  emacs-plus = pkgs.callPackage ./default.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa GSS IOKit ImageIO;
    withMojave = true;
    withNoTitlebar = true;
  };
in

emacs-plus
