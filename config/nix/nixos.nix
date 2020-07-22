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
    # Automatically detects files in the store that have identical contents.
    autoOptimiseStore = true;

    gc = {
      # Automatically run the Nix garbage collector daily.
      automatic = true;
      dates = "daily";
      # TODO: This one seems iffy...
      # # Run the collector automatically every 10 days.
      # options = "--delete-older-than 10d";
    };
  };
}
