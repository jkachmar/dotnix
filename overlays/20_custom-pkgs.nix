# Custom packages that are not currently provided within any of the nixpkgs
# package trees.
(
  _self: super: {
    emacs-plus = super.callPackage ./../pkgs/emacs-plus {
      inherit (super.darwin.apple_sdk.frameworks) Cocoa;

      # NOTE: Should we depend on 'self.emacsGit' (i.e. the final emacsGit
      # produced at the end of the overlay process.

      # Arguments.
      emacsDrv = super.emacsGit;

      # Options.
      withMojave = true;
      withNoTitlebar = false;
    };

    irccloud = super.callPackage ./../pkgs/irccloud {};
  }
)
