{ config, lib, ... }:

let
  inherit (lib) types;
  cfg = config.virtualisation.podman;
in {
  options.virtualisation.podman = {
    autoUpdate = lib.mkOption {
      type = types.bool;
      default = true;
      description = lib.mkDoc ''
        This option enables the 'podman-auto-update.timer' unit which triggers
        'podman-auto-update.service' daily at midnight (by default).

        This will update any running containers with the label 'io.containers.autoUpdate'
        and restart them.

        See https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html
        for details.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.timers.podman-auto-update.wantedBy = ["timers.target"];
  };
}
