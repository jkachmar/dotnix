{
  description = "jkachmar's personal dotfiles and machine configurations.";

  inputs = {
    ################
    # PACKAGE SETS #
    ################
    # Stable NixOS package set; pinned to the latest 23.05 release.
    nixosPkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # Unstable (rolling-release) NixOS package set.
    unstable.url = "github:nixos/nixpkgs";

    #############
    # UTILITIES #
    #############
    # Declarative user configuration for NixOS systems.
    nixosHome = {
      inputs.nixpkgs.follows = "nixosPkgs";
      url = "github:nix-community/home-manager/release-23.05";
    };
  };

  outputs = inputs@{ self, nixosPkgs, unstable, ... }:
    let
      # Utility function to construct a package set based on the given system
      # along with the shared `nixpkgs` configuration defined in this repo.
      mkPkgsFor = system: pkgset:
        import pkgset {
          inherit system;
          config = import ./config/system/nixpkgs/config.nix;
        };

      # Utility function to construct a NixOS configuration for arbitrary
      # systems.
      #
      # TODO: Push more of this functionality down down into the
      # `./config/machines` modules to avoid cluttering up `flake.nix` any
      # more than is necessary.
      mkNixOSConfiguration = hostname: system: nixosPkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixosPkgs.nixosModules.notDetected
          inputs.nixosHome.nixosModule
          # XXX: Nix needs to believe we have an absolute path here.
          (./. + "/hosts/${hostname}")
        ];
        specialArgs = {
          inherit inputs;
          pkgs = mkPkgsFor system nixosPkgs;
          unstable = mkPkgsFor system inputs.unstable;
        };
      };
    in
    {
      nixosConfigurations = {
        enigma = mkNixOSConfiguration "enigma" "x86_64-linux";
        star-platinum = mkNixOSConfiguration "star-platinum" "x86_64-linux";
      };
    };
}
