let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-darwin {};

  emacs-plus = pkgs.callPackage ./default.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa GSS IOKit ImageIO;
    libgccjit = import ../libgccjit { gcc = pkgs.gcc10; };
    withMojave = true;
    withNoTitlebar = false;
  };
in

emacs-plus
