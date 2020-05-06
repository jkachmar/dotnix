{ ... }:

{
  imports = [
    ./nix-path.nix
    ./boot.nix
    ./desktop.nix
    ./devtools.nix
    ./virtualization.nix
  ];

  # Remember that one time sudo broke?
  #
  # Maybe this helps...
  security.sudo.enable = true;

  # Sandboxing is much more convoluted under darwin
  #
  # See: https://github.com/NixOS/nix/issues/2311
  nix.useSandbox = true;
}
