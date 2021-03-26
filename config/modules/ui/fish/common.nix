###########################################
# OS-agnostic `fish` shell configuration. #
###########################################
{ ... }:
{
  primary-user.home-manager.programs.fish = {
    enable = true;
    # Consider enabling babelfish
    #
    # cf. https://github.com/malob/nixpkgs/blob/bd20ba8cccfa10957af1c1afd4ebf9aa2651ada7/darwin/modules/programs/nix-index.nix
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };
}
