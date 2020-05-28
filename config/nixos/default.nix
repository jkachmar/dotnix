{ ... }:

{
  imports = [
    ./nix.nix
    ./boot.nix
    ./desktop.nix
    ./devtools.nix
    ./virtualization.nix
  ];

  # Remember that one time sudo broke?
  #
  # Maybe this helps...
  security.sudo.enable = true;
}
