# Custom packages that are not currently provided within the nixpkgs package
# tree.
(
  self: _: {
    irccloud = self.callPackage ./../pkgs/irccloud {};
  }
)
