{ ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = true;
      };
      timeout = 5; # Boot loader timeout (in seconds)
    };
    plymouth.enable = true;
  };
}
