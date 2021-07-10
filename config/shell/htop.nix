#####################################
# OS-agnostic `htop` configuration. #
#####################################
{ ... }:
{
  primary-user.home-manager.programs.htop = {
    enable = true;
    settings = {
      hide_userland_threads = true;
      highlight_base_name = true;
      show_program_path = false;
      tree_view = true;
      vim_mode = true;
    };
  };
}
