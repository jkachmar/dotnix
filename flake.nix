{
  description = "jkachmar's personal dotfiles and machine configurations";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 20.09 release.
    nixosPkgs.url = "github:nixos/nixpkgs/nixos-20.09-small";
    # Stable Darwin nixpkgs package set; pinned to the 20.09 release.
    darwinPkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    # Tracks nixos/nixpkgs-channels unstable branch.
    #
    # Try to pull new/updated packages from 'unstable' whenever possible, as
    # these will likely have cached results from the last successful Hydra
    # jobset.
    unstable.url = "github:nixos/nixpkgs";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "darwinPkgs";
    };
    home.url = "github:nix-community/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, darwinPkgs, nixosPkgs, nix-darwin, ... }: {
    overlays = {
      # Inject 'unstable' into the overridden package set, so that the following
      # overlays  may access them (along with any system configs that wish to
      # do so).
      pkgSets = final: prev: {
        unstable = import sources.unstable { };
      };

      overriddenPkgs = import ../../../overlays/overridden_pkgs.nix;
      pinnedPkgs = import ../../../overlays/pinned_pkgs.nix;
      customPkgs = import ../../../overlays/custom_pkgs.nix;
    };

    nixosConfigurations.star-platinum = { };

    darwinConfigurations.white-album = nix-darwin.lib.darwinSystem {
      inherit inputs;
      modules = [ ./config/machines/white-album ];
    };
  };
}
