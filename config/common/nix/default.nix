{ pkgs, ... }:

let
  caches = import ./nixpkgs-caches.nix;
  substituters = caches.substituters;
  publicKeys = caches.keys;

  # FIXME: This is incredibly stupid, but I can't figure out a better way to
  # share the nixpkgs-config while still _only_ installing the Firefox Plasma
  # integration in the user-config for a NixOS user.
  #
  # The issue seems to stem from the fact that home-manager writes out the XDG
  # config files from a literal file when using the `.source` function, and Nix
  # cannot convert an attrset to a string to write it out with `.text`.
  nixpkgsCfg = ./nixpkgs-config.nix;
  nixosUserNixpkgsCfg = ./nixpkgs-config-nixos-user.nix;
  userCfg =
    if pkgs.stdenv.isDarwin
    then nixpkgsCfg
    else nixosUserNixpkgsCfg;
in

{
  # System-level configuration.
  nix = {
    binaryCaches = substituters;
    binaryCachePublicKeys = publicKeys;
  };

  nixpkgs.config = import nixpkgsCfg;

  # User-level configuration.
  primary-user.home-manager = {
    nixpkgs.config = import userCfg;
    xdg.configFile."nixpkgs/config.nix".source = userCfg;

    xdg.configFile."nix/nix.conf".text = ''
      # Keep GC roots associated with nix-shell from being cleaned
      keep-derivations = true
      keep-outputs = true

      trusted-substituters = ${toString substituters}
      trusted-public-keys = ${toString publicKeys}
    '';
  };
}
