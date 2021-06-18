####################################
# OS-agnostic `nix` configuration. #
####################################
{ lib, pkgs, ... }:

let
  # TODO: Abstract this out into its own module.
  caches = [
    # NixOS default cache.
    { 
      url = "https://cache.nixos.org";
      key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    }
  ];
  substituters = builtins.map (cache: cache.url) caches;
  trustedPublicKeys = builtins.map (cache: cache.key) caches;
in

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
    package = pkgs.nixUnstable;

    # FIXME: lol without this it forcibly adds the default nixos cache?
    #
    # There's gotta be a better solution to this...
    binaryCaches = lib.mkForce substituters;
    binaryCachePublicKeys = lib.mkForce trustedPublicKeys;
  };
  primary-user.home-manager.xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes ca-references

    substituters = ${lib.concatStringsSep " " substituters}
    trusted-public-keys = ${lib.concatStringsSep " " trustedPublicKeys}
  '';
}
