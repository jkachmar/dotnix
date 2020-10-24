{ ... }:

{
  # NOTE: 'lorri' is kinda rough in terms of tracking what the background
  # daemon has or hasn't processed; it's hard to tell when you're working with
  # an up-to-date cached shell or something stale.

  # imports = [ ./macos.nix ./nixos.nix ];

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
