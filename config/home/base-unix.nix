{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Basic utilities
    bat
    htop
    ripgrep
    unzip
    vim
    zstd

    # Encryption
    gnupg
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # Better userland for macOS
    coreutils
    emacsMacport
    findutils
    gawk
    gnugrep
    gnused
  ];

  programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = false;
  };
}
