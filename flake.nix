{
  description = "jkachmar's personal dotfiles and machine configurations.";

  inputs = {
    ################
    # PACKAGE SETS #
    ################

    # Stable macOS package set; pinned to the latest 21.11 release.
    #
    # `darwin` is used to indicate the most up-to-date stable packages tested
    # against macOS.
    macosPkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    # Stable NixOS package set; pinned to the latest 21.05 release.
    nixosPkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    # Unstable (rolling-release) NixOS package set.
    unstable.url = "github:nixos/nixpkgs";

    #############
    # UTILITIES #
    #############

    # Declarative, NixOS-style configuration for macOS.
    darwin = {
      inputs.nixpkgs.follows = "macosPkgs";
      url = "github:lnl7/nix-darwin";
    };

    # Declarative user configuration for macOS systems.
    macosHome = {
      inputs.nixpkgs.follows = "macosPkgs";
      url = "github:nix-community/home-manager/release-21.11";
    };
    # Declarative user configuration for NixOS systems.
    nixosHome = {
      inputs.nixpkgs.follows = "nixosPkgs";
      url = "github:nix-community/home-manager/release-21.05";
    };
  };

  outputs = inputs@{ self, darwin, macosPkgs, nixosPkgs, unstable, ... }:
    let
      # Utility function to construct a package set based on the given system
      # along with the shared `nixpkgs` configuration defined in this repo.
      mkPkgsFor = system: pkgset:
        import pkgset {
          inherit system;
          config = import ./config/system/nixpkgs/config.nix;
        };

      # Utility function to construct a macOS configuration for arbitrary
      # systems.
      #
      # TODO: Push more of this functionality down down into the
      # `./config/machines` modules to avoid cluttering up `flake.nix` any
      # more than is necessary.
      mkMacOSConfiguration = hostname: system: darwin.lib.darwinSystem {
        modules = [
          inputs.macosHome.darwinModule
          # XXX: Nix needs to believe we have an absolute path here.
          (./. + "/hosts/${hostname}")
        ];
        specialArgs = {
          inputs = inputs // {
            nixpkgs = macosPkgs;
          };
          pkgs = mkPkgsFor system macosPkgs;
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
          inputs.nixosHome.nixosModule
          # XXX: Nix needs to believe we have an absolute path here.
          # (./. + "/hosts/${hostname}")
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
        manhattan-transfer = mkMacOSConfiguration "manhattan-transfer" "aarch64-darwin";
      };

      nixosConfigurations = {
        enigma = mkNixOSConfiguration "enigma" "x86_64-linux";
        kraftwerk = mkNixOSConfiguration "kraftwerk" "x86_64-linux";
        star-platinum = mkNixOSConfiguration "star-platinum" "x86_64-linux";
      };
    };
}
