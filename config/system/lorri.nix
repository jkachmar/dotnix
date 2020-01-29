{ config, pkgs, ... }:

let
  inherit (pkgs) lorri;

in {
  environment.systemPackages = [ lorri ];
#   # XXX: Copied verbatim from https://github.com/target/lorri/issues/96#issuecomment-545152525
#   launchd.user.agents.lorri = {
#     serviceConfig = { 
#       ProgramArguments = [
#         "${lorri}/bin/lorri" "daemon"
#       ];
#       StandardOutPath = "/var/tmp/lorri.log";
#       StandardErrorPath = "/var/tmp/lorri.log";
#       EnvironmentVariables = {
#         PATH="${pkgs.nix}/bin";
#         NIX_PATH="/nix/var/nix/profiles/per-user/root/channels";
#       };
#       Sockets = [{
#         SockPathName = "/Users/jkachmar/Library/Caches/com.github.target.lorri.lorri.lorri/daemon.socket";
#       }];
#     };
#   };
# }

  # XXX: Copied verbatim from https://github.com/iknow/nix-channel/blob/7bf3584e0bef531836050b60a9bbd29024a1af81/darwin-modules/lorri.nix
  launchd.user.agents = {
    "lorri" = {
      serviceConfig = {
        WorkingDirectory = (builtins.getEnv "HOME");
        EnvironmentVariables = { };
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/tmp/lorri.log";
        StandardErrorPath = "/var/tmp/lorri.log";
      };
      script = ''
        source ${config.system.build.setEnvironment}
        exec ${lorri}/bin/lorri daemon
      '';
    };
  };
}
