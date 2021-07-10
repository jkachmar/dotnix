#############################################################################
# NixOS systemd-boot configuration.
#############################################################################
{ ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = true;
      };
      timeout = 10;
    };
  };
}