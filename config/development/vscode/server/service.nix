###########################
# VS Code Server SSH fix. #
###########################
{ lib, pkgs, ... }:

let
  nodePkg = pkgs.nodejs-16_x;

  # Placeholder for any additional packages that are needed by VS Code and/or
  # its extensions within the FHS user env.
  additionalFhsPkgs = with pkgs; [];

  # Adapted from nixpkgs.
  #
  # cf. https://github.com/NixOS/nixpkgs/blob/5a0e0d73b944157328d54c4ded1cf2f0146a86a5/pkgs/applications/editors/vscode/generic.nix#L141
  nodePkgFhs = pkgs.buildFHSUserEnvBubblewrap {
    name = nodePkg.name;

    # Libraries which are commonly needed for extensions.
    targetPkgs = pkgs: (with pkgs; [
      # ld-linux-x86-64-linux.so.2 and others
      glibc

      # dotnet
      curl
      icu
      libunwind
      libuuid
      openssl
      zlib

      # mono
      krb5
    ]) ++ additionalFhsPkgs;

    # Symlink shared assets, including icons and desktop entries.
    extraInstallCommands = ''
      ln -s "${nodePkg}/share" "$out/"
    '';

    runScript = "${nodePkg}/bin/node";

    # VS Code likes to kill the parent so that the GUI application isn't
    # attached to the terminal session.
    dieWithParent = false;

    passthru = {
      executableName = nodePkg.executableName;
      inherit (nodePkg) pname version;
    };

    meta = nodePkg.meta // {
      description = ''
        Wrapped variant of ${nodePkg.pname} which launches in a FHS compatible envrionment.
        Should allow for easy usage of extensions without nix-specific modifications.
      '';
    };
  };
in

{
  systemd.user.services.vscode-server-env-fixup = {
    description = "Monitor and automatically fix up VS Code Server environment";
    serviceConfig = {
      # When a monitored directory is deleted, it will stop being monitored.
      #
      # Even if it is later recreated it will not restart monitoring it.
      # 
      # Unfortunately the monitor does not kill itself when it stops
      # monitoring, so rather than creating our own restart mechanism, we
      # leverage systemd to do this for us.
      Restart = "always";
      RestartSec = 0;
      ExecStart = "${pkgs.writeShellScript "vscode-server-env-fixup.sh" ''
        set -euo pipefail
        PATH=${lib.makeBinPath (with pkgs; [ coreutils findutils inotify-tools ])}
        bin_dir=$HOME/.vscode-server/bin

        # Fix any existing symlinks before we enter the inotify loop.
        if [[ -e $bin_dir ]]; then
          find "$bin_dir" -mindepth 2 -maxdepth 2 -name node -exec ln -sfT ${nodePkgFhs}/bin/node {} \;
          find "$bin_dir" -path '*/@vscode/ripgrep/bin/rg' -exec ln -sfT ${pkgs.ripgrep}/bin/rg {} \;
        else
          mkdir -p "$bin_dir"
        fi

        while IFS=: read -r bin_dir event; do
          # A new version of the VS Code Server is being created.
          if [[ $event == 'CREATE,ISDIR' ]]; then
            # Create a trigger to know when their node is being created and replace it for our symlink.
            touch "$bin_dir/node"
            inotifywait -qq -e DELETE_SELF "$bin_dir/node"
            ln -sfT ${nodePkgFhs}/bin/node "$bin_dir/node"
            ln -sfT ${pkgs.ripgrep}/bin/rg "$bin_dir/node_modules/@vscode/ripgrep/bin/rg"

          # The monitored directory is deleted, e.g. when "Uninstall VS Code Server from Host" has been run.
          elif [[ $event == DELETE_SELF ]]; then
            # See the comments above Restart in the service config.
            exit 0
          fi
        done < <(inotifywait -q -m -e CREATE,ISDIR -e DELETE_SELF --format '%w%f:%e' "$bin_dir")
      ''}";
    };
    wantedBy = [ "default.target" ];
  };
}
