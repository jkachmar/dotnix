let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-darwin {};
  unstable = import sources.nixpkgs-unstable {};

  emacs-plus = pkgs.callPackage ./default.nix {
    gcc = unstable.gcc10;
    inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa GSS IOKit ImageIO;
    withMojave = true;
    withNoTitlebar = false;
  };
in

emacs-plus
