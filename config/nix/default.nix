###############################################################################
# Platform-agnostic Nix system configuration.
###############################################################################
{ inputs, pkgs, ... }:
let
  caches = import ./caches.nix;
  nixpkgsConfig = ./nixpkgs-config.nix;
in
{
  imports = [ ./macos.nix ./nixos.nix ];

  #############################################################################
  # System-level configuration.
  nix = {
    binaryCaches = caches.substituters;
    binaryCachePublicKeys = caches.keys;
    # XXX: Don't enable 'auto-optimise-store = true' 
    #
    # cf. https://github.com/NixOS/nix/issues/1522
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';

    # Auto-upgrade Nix package; use latest version (i.e. with flakes support).
    package = pkgs.nixFlakes;
  };

  nixpkgs = {
    config = import nixpkgsConfig;
  };

  # XXX: This feels like it should live in a different module...
  time.timeZone = "America/New_York";

  #############################################################################
  # User-level configuration.
  primary-user.home-manager = {
    xdg = {
      enable = true;
      configFile."nixpkgs/config.nix".source = nixpkgsConfig;
      configFile."nix/nix.conf".text = ''
        experimental-features = nix-command flakes ca-references
        substituters = ${toString caches.substituters}
        trusted-public-keys = ${toString caches.keys}
      '';
    };
  };
}
