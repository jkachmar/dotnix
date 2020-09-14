# Custom packages that are not currently provided within any of the nixpkgs
# package trees.
{ ... }:

_final: prev: {
  customNodePackages = prev.callPackage ./../pkgs/node-packages {};
  emacs-plus = prev.callPackage ./../pkgs/emacs-plus {
    inherit (prev.darwin.apple_sdk.frameworks) Cocoa;

    # NOTE: Should we depend on 'self.emacsGit' (i.e. the final emacsGit
    # produced at the end of the overlay process.

    # Arguments.
    emacsDrv = prev.emacsGit;

    # Options.
    withMojave = true;
    withNoTitlebar = false;
  };

  irccloud = prev.callPackage ./../pkgs/irccloud {};
}
