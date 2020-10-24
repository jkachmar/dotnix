{ ... }:

{
  imports = [ ./macos.nix ./nixos.nix ];

  primary-user.home-manager = {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNixDirenvIntegration = true;
    };
  };
}
