{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # Better userland for macOS
      coreutils
      emacsMacport
      findutils
      gawk
      gnugrep
      gnused
    ];
  };
}
