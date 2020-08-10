# Custom packages that are not currently provided within the nixpkgs package
# tree.
(
  self: super: {
    emacs-plus = self.callPackage ./../pkgs/emacs-plus {
      inherit (self.darwin.apple_sdk.frameworks) Cocoa;

      # Arguments.
      emacsDrv = super.emacsGit;
      # Options.
      withMojave = true;
      withNoTitlebar = false;
    };

    irccloud = self.callPackage ./../pkgs/irccloud {};
  }
)
