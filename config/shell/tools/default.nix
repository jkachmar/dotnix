#############################
# OS-agnostic system tools. #
#############################
{ lib, pkgs, unstable, ... }:
let
  inherit (lib) optionals;
  inherit (pkgs.stdenv.targetPlatform) isDarwin isLinux;

  gcoreutils = pkgs.coreutils.override {
    singleBinary = false;
    withPrefix = true;
  };
in
{
  environment.systemPackages = with pkgs; [
    # Misc. common programs without a better place to go.
    curl
    libvterm-neovim
    nixpkgs-fmt
    vim
    wget
  ] ++ optionals isDarwin [
    gcoreutils
  ] ++ optionals isLinux [
  ];

  primary-user.home-manager.home.packages = with pkgs; [
    # Misc. common programs without a better place to go.
    bat
    fd
    findutils
    htop
    mosh
    ripgrep
    shellcheck
  ] ++ optionals isDarwin [
    coreutils # XXX: lol, macOS (BSD) coreutils are broken?
  ] ++ optionals isLinux [
    nix-index # NOTE: Build is broken on macOS for now.
  ];
}
