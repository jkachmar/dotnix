# Custom packages that are not currently provided within the nixpkgs package
# tree.
(
  self: _: {
    emacs-plus = self.callPackage ./../pkgs/emacs-plus {
      inherit (self.darwin.apple_sdk.frameworks)
        AppKit Cocoa GSS IOKit ImageIO
        ;
      withMojave = true;
      withNativeComp = true;
      # withNoTitlebar = true;
    };

    irccloud = self.callPackage ./../pkgs/irccloud {};
  }
)
