{ ... }:

{
  imports = [
    ./nix-path.nix
    ./devtools
  ];

  # On macOS, multi-user Nix installs _must_ ensure that the daemon is enabled.
  services.nix-daemon.enable = true;
}
