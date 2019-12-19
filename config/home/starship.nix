{ pkgs, ... }:

{
  programs = {
    starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;
        line_break.disabled = true;
        username.show_always = true;
      };
    };
  };
}
