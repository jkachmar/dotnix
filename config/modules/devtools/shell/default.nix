{ lib, pkgs, ... }:

let
  inherit (lib) mkForce;
in

{
  imports = [ ./macos.nix ];

  environment.systemPackages = with pkgs; mkForce [
    # Shells.
    bash
    fish
    zsh
    # Misc. common programs without a better place to go.
    curl
    libvterm-neovim
    vim
    wget
  ];

  programs = {
    bash.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };

  primary-user.home-manager = {
    home.packages = with pkgs; mkForce [
      # Shells.
      mosh
      # Misc. common programs without a better place to go.
      bat
      fd
      htop
      niv
      ripgrep
      shellcheck
    ];

    # My preferred shell; it should be installed and enabled globally, but
    # preferentially configured by 'home-manager'.
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';
    };

    # Fancy shell prompt.
    programs.starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;
        # git_status can hang on large projects
        git_status.disabled = true;
        # haskell module is very slow for some reason
        haskell.disabled = true;
        line_break.disabled = true;
        username.show_always = true;
      };
    };
  };
}
