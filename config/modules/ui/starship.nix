######################################################
# OS-agnostic `starship` shell prompt configuration. #
######################################################
{ config, ... }:
{
  primary-user.home-manager.programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      # git_status can hang on large projects
      git_status.disabled = true;
      # haskell module is very slow for some reason
      haskell.disabled = true;
      line_break.disabled = true;
      username.show_always = true;
    };

    # Conditionally enable shell integrations.
    enableBashIntegration =
      config.primary-user.home-manager.programs.bash.enable;
    enableFishIntegration =
      config.primary-user.home-manager.programs.fish.enable;
    enableZshIntegration =
      config.primary-user.home-manager.programs.zsh.enable;
  };
}
