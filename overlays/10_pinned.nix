# Packages that are pinned with Niv to newer version than are in the nixpkgs
# stable package tree.
(
  self: _: {
    niv = self.callPackage ./../pkgs/niv {};
  }
)
