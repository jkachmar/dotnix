{ lib, ... }:
let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux;
in

{
  imports = [ (if isLinux then ./nixos.nix else ./darwin.nix) ];
  time.timeZone = "America/New_York";
}
