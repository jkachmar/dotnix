#####################################
# OS-agnostic `tmux` configuration. #
#####################################
{ config, lib, ... }:
let
  inherit (lib) optionalString;

  fishCfg = config.primary-user.home-manager.programs.fish;
  isFishEnabled = fishCfg.enable;
  fish = fishCfg.package;
in
{
  config.primary-user.home-manager.programs.tmux = {
    enable = true;
    keyMode = "vi";
    # XXX: Trying to do this with `mkIf` and `mkMerge` results in infinite
    # recursion.
    #
    # XXX: `defaultShell` is set to `null` upstream in `home-manager`, but not
    # exposed in a way that we can access without infinite recursion.
    #
    # XXX: `shell` is only enabled in a newer version of `home-manager`.
    #
    # shell = if isFishEnabled then "${fish}/bin/fish" else null;

    # NOTE: In lieu of just being able to set `shell`, manually define it in
    # `extraConfig` accordingly.
    #
    # cf. https://github.com/nix-community/home-manager/pull/875
    extraConfig = ''
      ${optionalString isFishEnabled ''
        # We need to set default-shell before calling new-session
        set  -g default-shell "${fish}/bin/fish"
      ''}
      # XXX: Due to how the default shell is being configured, `new-session`
      # should never be used and (instead) be defined equivalently inline as
      # follows (if it is so desired):
      #
      # new-session
    '';
  };
}
