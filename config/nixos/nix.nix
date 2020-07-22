{ lib, ... }:

{
  nix = {
    # Sandboxing is much more convoluted under darwin, not so on NixOS.
    #
    # See: https://github.com/NixOS/nix/issues/2311
    #
    # NOTE: nix-2.3.5 should fix this on darwin; if it does, unify this between
    # the two configs.
    useSandbox = true;

    # This replicates some of the nix.conf settings configured in 
    # '$dotfiles/config/common/nix/default.nix'.
    #
    # Those are user-level settings, which diverge (slightly) from system-level
    # settings (which are slightly different between NixOS and nix-darwin).
    # 
    # XXX: Should the binary caches be added here, as well, so that system-level
    # packages can pull from them?
    #
    # NOTE: Keep this in sync with '$dotfiles/config/darwin/nix.nix'
    extraOptions = ''
      # Keep GC roots associated with nix-shell from being cleaned
      keep-derivations = true
      keep-outputs = true
    '';

    nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
      nixpkgs = toString <nixpkgs>;
      nixpkgs-overlays = toString <nixpkgs-overlays>;
      # TODO: Evaluate if this is actually useful now that the overlays are
      # being set in ./default.nix
      # nixpkgs-overlays = toString <nixpkgs-overlays>;
      nixos-config = toString <nixos-config>;
    };
  };
}
