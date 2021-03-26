####################################
# OS-agnostic `nix` configuration. #
####################################
{ pkgs, ... }:
{
  # TODO: Set up binary caches.
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes ca-references
    '';
    package = pkgs.nixFlakes;
  };
  primary-user.home-manager.xdg.configFile."nix/nix.conf".text = ''
    experimental-features = nix-command flakes ca-references
  '';
}
