{
  description = "jkachmar's personal dotfiles and machine configurations.";

  inputs = {
    ################
    # PACKAGE SETS #
    ################

    # Stable macOS package set; pinned to the latest 20.09 release.
    #
    # `darwin` is used to indicate the most up-to-date stable packages tested
    # against macOS.
    macosPkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    # Stable NixOS package set; pinned to the latest 20.09 release.
    #
    # `small` is used to indicate the most up-to-date stable packages.
    nixosPkgs.url = "github:nixos/nixpkgs/nixos-20.09-small";
    # Unstable (rolling-release) NixOS package set.
    unstable.url = "github:nixos/nixpkgs";

    #############
    # UTILITIES #
    #############

    # Declarative, NixOS-style configuration for macOS.
    #
    # XXX: Updated to the latest unstable branch due to compatibility issues
    # with macOS 11.x (Big Sur); revisit when 21.05 drops.
    #
    # cf. https://github.com/LnL7/nix-darwin/issues/255
    darwin = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:lnl7/nix-darwin";
    };

    # Declarative user configuration for macOS systems.
    #
    # XXX: Updated to the latest unstable branch due to compatibility issues
    # with macOS 11.x (Big Sur); revisit when 21.05 drops.
    #
    # cf. https://github.com/LnL7/nix-darwin/issues/255
    macosHome = {
      inputs.nixpkgs.follows = "unstable";
      url = "github:nix-community/home-manager";
    };
    # Declarative user configuration for NixOS systems.
    nixosHome = {
      inputs.nixpkgs.follows = "nixosPkgs";
      url = "github:nix-community/home-manager/release-20.09";
    };

    # Declarative, persistent state management for ephemeral systems.
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ self, darwin, nixosPkgs, unstable, ... }:
    let
      # Utility function to construct a package set based on the given system
      # along with the shared `nixpkgs` configuration defined in this repo.
      mkPkgsFor = system: pkgset:
        import pkgset {
          inherit system;
          config = import ./config/modules/system/nixpkgs/config.nix;
        };

      # Utility function to construct a macOS configuration for arbitrary
      # systems.
      #
      # TODO: Push more of this functionality down down into the
      # `./config/machines` modules to avoid cluttering up `flake.nix` any
      # more than is necessary.
      mkMacOSConfiguration = hostname: system: darwin.lib.darwinSystem {
        modules = [
          inputs.macosHome.darwinModules.home-manager
          # XXX: Nix needs to believe we have an absolute path here.
          (./. + "/config/machines/${hostname}")
        ];
        specialArgs = {
          # XXX: Tracking unstable to work around compatibility issues with
          # macOS 11.x (Big Sur).
          inputs = inputs // {
            nixpkgs = unstable;
          };
          # XXX: Tracking unstable to work around compatibility issues with
          # macOS 11.x (Big Sur).
          pkgs = mkPkgsFor system unstable;
          unstable = mkPkgsFor system unstable;
        };
      };

      # Utility function to construct a NixOS configuration for arbitrary
      # systems.
      #
      # TODO: Push more of this functionality down down into the
      # `./config/machines` modules to avoid # cluttering up `flake.nix` any
      # more than is necessary.
      mkNixOSConfiguration = hostname: system: nixosPkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixosPkgs.nixosModules.notDetected
          inputs.nixosHome.nixosModules.home-manager
          inputs.impermanence.nixosModules.impermanence
          # XXX: Nix needs to believe we have an absolute path here.
          (./. + "/config/machines/${hostname}")
        ];
        specialArgs = {
          inherit inputs;
          pkgs = mkPkgsFor system nixosPkgs;
          unstable = mkPkgsFor system inputs.unstable;
        };
      };
    in
    {
      darwinConfigurations = {
        crazy-diamond = mkMacOSConfiguration "crazy-diamond" "x86_64-darwin";
      };

      nixosConfigurations = {
        star-platinum = mkNixOSConfiguration "star-platinum" "x86_64-linux";
      };
    };
}
