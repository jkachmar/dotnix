#
{
  description = "jkachmar's personal dotfiles and machine configurations.";

  inputs = {
    # Pure utility functions for working with Flakes.
    utils.url = "github:numtide/flake-utils";
    # Stable NixOS package set; pinned to the latest 20.09 release.
    #
    # `small` is used to pull the most up-to-date stable packages.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09-small";
    # Unstable (rolling-release) NixOS package set.
    unstable.url = "github:nixos/nixpkgs";
    # Declarative fleet management for NixOS machines.
    nixops = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "utils";
      url = "github:nixos/nixops";
    };
    # Declarative user configuration.
    home = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-20.09";
    };
    # Declarative, persistent state management for ephemeral systems.
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ self, nixpkgs, unstable, home, impermanence, ... }:
    let
      # Utility function to construct a package set based on the given system
      # along with the shared `nixpkgs` configuration defined in this repo.
      mkPkgsFor = system: pkgset:
        import pkgset {
          inherit system;
          config = import ./config/modules/system/nixpkgs/config.nix;
        };
      # Utility function to construct a NixOS configuration for arbitrary
      # systems.
      #
      # TODO: Push more of this functionality down down into the
      # `./config/machines` modules to avoid # cluttering up `flake.nix` any
      # more than is necessary.
      mkNixOSConfiguration = hostname: system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixpkgs.nixosModules.notDetected
          home.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          # XXX: Nix needs to believe we have an absolute path here.
          (./. + "/config/machines/${hostname}")
        ];
        specialArgs = {
          inherit inputs;
          pkgs = mkPkgsFor system nixpkgs;
          unstable = mkPkgsFor system unstable;
        };
      };
    in
    {
      nixosConfigurations = {
        star-platinum = mkNixOSConfiguration "star-platinum" "x86_64-linux";
      };
    };
}
