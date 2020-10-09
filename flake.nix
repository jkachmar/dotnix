{
  description = "jkachmar's personal dotfiles and machine configurations";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 20.03 release.
    nixosPkgs.url = "github:nixos/nixpkgs-channels/nixos-20.03-small";
    # Stable Darwin nixpkgs package set; pinned to the 20.03 release.
    darwinPkgs.url = "github:nixos/nixpkgs-channels/nixpkgs-20.03-darwin";
    # Tracks nixos/nixpkgs-channels unstable branch.
    #
    # Try to pull new/updated packages from 'unstable' whenever possible, as
    # these will likely have cached results from the last successful Hydra
    # jobset.
    unstable.url = "github:nixos/nixpkgs-channels/nixos-unstable";
    # Tracks nixos/nixpkgs main branch.
    #
    # Only pull from 'trunk' when channels are blocked by a Hydra jobset
    # failure or the 'unstable' channel has not otherwise updated recently for
    # some other reason.
    trunk.url = "github:nixos/nixpkgs";
    # TODO: Switch to nix-darwin's main branch when flakes have been merged.
    nix-darwin.url = "github:LnL7/nix-darwin/flakes";
    home.url = "github:nix-community/home-manager";
    emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, darwinPkgs, nixosPkgs, ... }: {
    overlays = {
      # Inject 'unstable' and 'trunk' into the overridden package set, so that
      # the following overlays may access them (along with any system configs
      # that wish to do so).
      pkg-sets = (
        final: prev: {
          unstable = import inputs.unstable { system = final.system; };
          trunk = import inputs.trunk { system = final.system; };
        }
      );

      overridden_pkgs = import ./overlays/overridden_pkgs.nix;
      pinned_pkgs = import ./overlays/pinned_pkgs.nix;
      custom_pkgs = import ./overlays/custom_pkgs.nix;
    };

    nixosConfigurations = {
      star-platinum = {};
    };

    darwinConfigurations = {
      white-album =
        let
          configuration = {
            imports = [
              inputs.home.darwinModules.home-manager
              ./machines/white-album
            ];
          };

          result = import inputs.nix-darwin {
            inherit configuration inputs;
            nixpkgs = darwinPkgs;
            system = "x86_64-darwin";
          };
        in
          result.system;
    };
  };
}
