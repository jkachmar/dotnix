{ ... }:
let
  sources = ../../nix/sources.nix;
in

{
  imports = [
    "${sources.home-manager}/nixos"
  ];

  # NixOS version.
  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
    };
  };

  nix = {
    # Darwin sandboxing is still broken.
    # https://github.com/NixOS/nix/issues/2311
    #
    # Unify this once everything works again.
    useSandbox = true;

    # Automatically detects files in the store that have identical contents.
    autoOptimiseStore = true;

    nixPath = lib.mapAttrsToList (k: v: "${k}=${v}") {
      nixpkgs = sources.nixpkgs-nixos;
      nixpkgs-overlays = ../../overlays;
      nixos-config = toString <nixos-config>;
    };

    # # TODO: This one seems iffy...
    # gc = {
    #   # Automatically run the Nix garbage collector daily.
    #   automatic = true;
    #   dates = "daily";
    #   # Run the collector automatically every 10 days.
    #   options = "--delete-older-than 10d";
    # };
  };
}
