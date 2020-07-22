{ lib, ... }:
let
  inherit (lib.systems.elaborate { system = builtins.currentSystem; }) isLinux;
in

{
  imports = [ (if isLinux then ./nixos.nix else ./darwin.nix) ];
  time.timeZone = "America/New_York";
  nixpkgs.overlays =
    let
      path = ../../overlays;
    in
      with builtins;
      map (n: import (path + ("/" + n)))
        (
          filter (
            n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix"))
          )
            (attrNames (readDir path))
        );
}
