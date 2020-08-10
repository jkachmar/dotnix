# Custom packages that are not currently provided within the nixpkgs package
# tree.
(
  self: super: {
    emacs-plus = self.callPackage ./../pkgs/emacs-plus {
      inherit (super) libgccjit; # Comes from ./20_custom.nix
      inherit (self.darwin.apple_sdk.frameworks)
        AppKit Cocoa GSS IOKit ImageIO
        ;

      # Options.
      withMojave = true;
      withNativeComp = true;
      # withNoTitlebar = true;
    };

    irccloud = self.callPackage ./../pkgs/irccloud {};
  }
)
