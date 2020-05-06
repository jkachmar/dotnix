{ ... }:

{
  imports = [
    ./nix-path.nix
    ./devtools
  ];

  # On macOS, multi-user Nix installs _must_ ensure that the daemon is enabled.
  services.nix-daemon.enable = true;

  # Sandboxing is much more convoluted under darwin
  #
  # See: https://github.com/NixOS/nix/issues/2311
  nix.useSandbox = false;
}
