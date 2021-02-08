{
  description = "jkachmar's personal dotfiles and machine configurations";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 20.09 release.
    nixosPkgs.url = "github:nixos/nixpkgs/nixos-20.09-small";
    # Stable Darwin nixpkgs package set; pinned to the 20.09 release.
    darwinPkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    # Tracks nixos/nixpkgs-channels unstable branch.
    unstable.url = "github:nixos/nixpkgs";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "darwinPkgs";
    };
    home.url = "github:nix-community/home-manager/release-20.09";
    # emacs.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs@{ self, darwin, darwinPkgs, nixosPkgs, unstable, ... }: {
    # Personal MacBook Pro configuration.
    darwinConfigurations = {
      # Experimental darwin flake setup.
      #
      # TODO: Factor some of this back out, or unify with other machine
      # configruations.
      crazy-diamond = darwin.lib.darwinSystem {
        inputs = {
          inherit darwin unstable;
          config-path = "$HOME/.config/dotfiles/current-machine";
          nixpkgs = darwinPkgs;
        };
        modules = [
          inputs.home.darwinModules.home-manager
          ./machines/crazy-diamond
        ];
      };
    };
    devShell = {
      x86_64-darwin = import ./shell.nix {
        inherit inputs;
        config-path = "$HOME/.config/dotfiles/current-machine";
        pkgs = import darwinPkgs {
          system = "x86_64-darwin";
        };
      };
    };
  };
}
