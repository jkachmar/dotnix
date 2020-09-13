{
  description = "jkachmar's personal dotfiles and machine configurations";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 20.03 release.
    nixosPkgs.url = "github:nixos/nixpkgs-channels/nixos-20.03-small";
    # Stable Darwin nixpkgs package set; pinned to the 20.03 release.
    darwinPkgs.url = "github:nixos/nixpkgs-channels/nixpkgs-20.03-darwin";
    # Unstable nixpkgs package set.
    #
    # More recent than the stable set, the results are likely to be cached.
    unstable.url = "github:nixos/nixpkgs-channels/nixos-unstable";
    # Primary nixpkgs development repository
    #
    # Most recent package set, however the results are unlikely to be cached.
    trunk.url = "github:nixos/nixpkgs";
    # TODO: Switch to nix-darwin's main branch when flakes have been merged.
    nix-darwin.url = "github:LnL7/nix-darwin/flakes";
    home.url = "github:nix-community/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, darwinPkgs, nixosPkgs, ... }: {
    overlays = {
      # "00_overrides" = import ./overlays/00_overrides.nix {
      #   inherit (inputs) unstable trunk;
      # };
      "10_pins" = import ./overlays/10_pins.nix {};
      "15_emacs" = import inputs.emacs;
      "20_custom-pkgs" = import ./overlays/20_custom-pkgs.nix {};
    };

    nixosConfigurations = {
      star-platinum = {};
    };

    darwinConfigurations = {
      white-album = import machines/white-album {
        inherit (inputs) home nix-darwin;
        stablePkgs = darwinPkgs;
        unstablePkgs = inputs.unstable;
        trunkPkgs = inputs.trunk;
        overlays = builtins.attrValues self.overlays;
      };
    };
  };
}
