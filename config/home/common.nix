{ pkgs, ... }:

{
  # ACHTUNG! - The `nixpkgs.config` attribute needs to be set both in 
  # home-manager and in the NixOS/nix-darwin system configuration
  nixpkgs.config = import ../nix/nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ../nix/nixpkgs-config.nix;

  home.packages = with pkgs; [
    # Shells with TCP/IP are for suckers
    mosh

    # The fastest grep clone from the rustiest language
    ripgrep

    # Transparent proxies + VPN + SSH
    sshuttle
  ];

  programs = {
    # A `cat` clone that supports syntax highlighting (and other goodies!)
    bat.enable = true;

    # Automagical loading and unloading of shell environments
    direnv = {
      enable = true;
      enableFishIntegration = true;
    };

    # Finally, a command line shell for the 90s
    fish = {
      enable = true;
      interactiveShellInit = ''
        fish_vi_key_bindings
      '';
    };

    # I can't believe it's not CVS
    git = {
      enable = true;
      ignores = [
        ".DS_Store"
      ];
      userEmail = "joseph.kachmar@gmail.com";
      userName = "Joe Kachmar";
    };

    # Let Home Manager install and manage itself
    home-manager.enable = true;

    # POSIX top with a snazzy paint job
    htop.enable = true;

    # Bram Moolenaar spends too much time on Google Calendar these days
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    # A cross-shell prompt that no astronaut has ever used
    starship = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        add_newline = false;
        # git_status can hang on large projects
        git_status.disabled = true;
        line_break.disabled = true;
        username.show_always = true;
      };
    };
  };
}
