{ lib, ... }:

{

  # On macOS, multi-user Nix installs _must_ ensure that the daemon is enabled.
  services.nix-daemon.enable = true;

  # Sandboxing is much more convoluted under darwin
  #
  # See: https://github.com/NixOS/nix/issues/2311
  #
  # NOTE: This should be fixed on nix-2.3.5; try enabling it after upgrading.
  nix.useSandbox = true;

  # This replicates some of the nix.conf settings configured in 
  # '$dotfiles/config/common/nix/default.nix'.
  #
  # Those are user-level settings, which diverge (slightly) from system-level
  # settings (which are slightly different between NixOS and nix-darwin).
  #
  # XXX: Should the binary caches be added here, as well, so that system-level
  # packages can pull from them?
  #
  # NOTE: Keep this in sync with '$dotfiles/nixos/darwin/nix.nix'
  nix.extraOptions = ''
    # Keep GC roots associated with nix-shell from being cleaned
    gc-keep-derivations = true
    gc-keep-outputs = true
  '';

  # NOTE: If `environment.darwinConfig` is _not_ set, then nix-darwin defaults
  # to some location in the home directory
  #
  # If it's set _in addition to_ `darwin-config` on the NIX_PATH, then
  # duplicate entries will be present
  environment.darwinConfig = toString <darwin-config>;
  nix.nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
    darwin = toString <darwin>;
    nixpkgs = toString <nixpkgs>;
    nixpkgs-overlays = toString <nixpkgs-overlays>;
  };
}
