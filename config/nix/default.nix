{ lib, ... }:
let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux;
  caches = import ./caches.nix;
  nixpkgsConfig = ./nixpkgs-config.nix;
  overlays =
    let
      path = ../../overlays;
    in
      with builtins;
      map (n: import (path + ("/" + n)))
        (
          filter (
            n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))
          )
            (attrNames (readDir path))
        );
in

{
  imports = [
    (if isLinux then ./nixos.nix else ./darwin.nix)
  ];

  #############################################################################
  # System-level configuration.

  time.timeZone = "America/New_York";

  nixpkgs = {
    inherit overlays;
    config = import nixpkgsConfig;
  };

  nix = {
    binaryCaches = caches.substituters;
    binaryCachePublicKeys = caches.keys;

    # XXX: Can this self-referential, or at least something that can be
    # non-destructively appended to?
    # nixPath = nix.nixPath ++ lib.mapAttrsToList (k: v: "${k}=${v}") {
    #   nixpkgs-overlays = overlaysPath;
    # };
  };

  #############################################################################
  # User-level configuration.
  primary-user.home-manager = {
    nixpkgs = {
      inherit overlays;
      config = import nixpkgsConfig;
    };

    xdg = {
      enable = true;
      configFile."nixpkgs/config.nix".source = nixpkgsConfig;
      configFile."nix/nix.conf".text = ''
        # Keep GC roots associated with nix-shell from being cleaned
        keep-derivations = true
        keep-outputs = true

        trusted-substituters = ${toString caches.substituters}
        trusted-public-keys = ${toString caches.keys}
      '';
    };
  };
}
