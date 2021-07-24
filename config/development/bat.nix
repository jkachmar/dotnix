####################################
# OS-agnostic `bat` configuration. #
####################################
{ pkgs, ... }:

{
  primary-user.home-manager.programs.bat = {
    enable = true;
    config = {
      # This theme _should_ follow the terminal's light/dark theme choices.
      #
      # cf. https://github.com/sharkdp/bat/issues/1104
      theme = "base16";
    };
  };
}
