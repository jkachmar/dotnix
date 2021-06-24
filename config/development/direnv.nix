#######################################
# OS-agnostic `direnv` configuration. #
#######################################
{ config, ... }:
{
  primary-user.home-manager.programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # Conditionally enable shell integrations.
    enableBashIntegration =
      config.primary-user.home-manager.programs.bash.enable;
    enableFishIntegration =
      config.primary-user.home-manager.programs.fish.enable;
    enableZshIntegration =
      config.primary-user.home-manager.programs.zsh.enable;
  };
}
