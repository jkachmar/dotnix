[
  (
    self: _: {
      irccloud = self.callPackage ./pkgs/irccloud {};
    }
  )

  (
    self: _: {
      niv = self.callPackage ./pkgs/niv {};
    }
  )
]
