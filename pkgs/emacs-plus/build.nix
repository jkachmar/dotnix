let
  sources = import ../../nix/sources.nix;
  pkgs = import sources.nixpkgs-unstable {
    overlays = [ (import sources.emacs-overlay) ];
  };
in
pkgs.callPackage ./default.nix {
  inherit (pkgs.darwin.apple_sdk.frameworks) AppKit Cocoa;
  emacs = pkgs.emacsGit;
  withMojave = true;
  withNoTitlebar = false;
}
