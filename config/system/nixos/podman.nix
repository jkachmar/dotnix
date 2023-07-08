##########################################################
# NixOS ZFS + Podman-based virtualization configuration. #
##########################################################
{ pkgs, ... }:

{
  #############################################################################
  # VIRTUALIZATION
  #############################################################################
  # Use Podman to run OCI containers.
  virtualisation = {
    containers = {
      enable = true;
      storage.settings.storage = {
        driver = "zfs";
        graphroot = "/persist/podman/containers";
        runroot = "/run/containers/storage";
      };
    };

    podman = {
      enable = true;
      autoUpdate = true;
      # NOTE: Workaround for https://github.com/NixOS/nixpkgs/pull/112443
      extraPackages = [ pkgs.zfs ];
    };

    oci-containers.backend = "podman";
  };
}
