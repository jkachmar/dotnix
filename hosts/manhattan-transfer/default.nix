{ config, ... }:
{
  imports = [
    ./hardware.nix
    ../../profiles/macos.nix
    # ../../modules/system/primary-user/macos.nix
    # ../../config/system/nix/macos.nix
  ];

  config = {
    networking.hostName = "manhattan-transfer";

    primary-user = {
      name = "jkachmar";
      git.user.name = config.primary-user.name;
      git.user.email = "git@jkachmar.com";
      user.home = /Users/jkachmar;
    };

    homebrew = {
      brewPrefix = "/opt/homebrew/bin";
      extraConfig = ''
        tap "microsoft/mssql-release", "https://github.com/microsoft/homebrew-mssql-release"
      '';
      brews = [
        "libffi"
        "libpq"
        "llvm@11"
        "msodbcsql17"
        "mssql-tools"
        "mysql-client@5.7"
        "node@14"
        "openssl"
        "pcre"
        "unixodbc"
      ];
      casks = [
        "firefox" # A good web browser.
        "iterm2" # A better terminal emulator.
        "keepassxc" # An alternative password manager.
        "slack" # Business chat.
      ];
    };

    # TODO: Abstract this out.
    services.nix-daemon.enable = true;
    users.nix.configureBuildUsers = true;

    ###########################################################################
    # Used for backwards compatibility, please read the changelog before
    # changing.
    #
    # $ darwin-rebuild changelog
    system.stateVersion = 4;
  };
}
