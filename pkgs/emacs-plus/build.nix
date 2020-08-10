let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-darwin {};
  unstable = import sources.nixpkgs-unstable {};

  emacs-plus = pkgs.callPackage ./default.nix {
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa GSS IOKit ImageIO;
    libgccjit = unstable.libgccjit;
    withMojave = true;
    withNoTitlebar = true;
  };
in

emacs-plus
