{ pkgs, ... }:

{
  primary-user.home-manager = {
    # Use the top-level nixpkgs.
    #
    # Since home-manager doesn't have configuration options for `lorri` yet, it
    # will have to be configured by `launchd` (outside of the scope of this
    # configuration block).
    home.packages = with pkgs; [ lorri ];
  };

  # TODO: Does this actually help? I feel like I always need to hit a project
  # with `lorri watch --once` to be _sure_ it's cached...
  #
  # XXX: Copied (nearly) verbatim from https://github.com/iknow/nix-channel/blob/7bf3584e0bef531836050b60a9bbd29024a1af81/darwin-modules/lorri.nix
  # launchd.user.agents = {
  #   "lorri" = {
  #     serviceConfig = {
  #       WorkingDirectory = (builtins.getEnv "HOME");
  #       EnvironmentVariables = {};
  #       KeepAlive = true;
  #       RunAtLoad = true;
  #       StandardOutPath = "/var/tmp/lorri.log";
  #       StandardErrorPath = "/var/tmp/lorri.log";
  #     };
  #     script = ''
  #       source ${config.system.build.setEnvironment}
  #       exec ${pkgs.lorri}/bin/lorri daemon
  #     '';
  #   };
  # };
}
