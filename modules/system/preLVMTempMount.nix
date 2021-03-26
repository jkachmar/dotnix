# This module is courtesy of Conor Prussin's dotfiles:
#
# https://github.com/cprussin/dotfiles/blob/d6730b1ae9a5d7d2acbf440693f8656134f69914/modules/nixos/preLVMTempMount.nix
{ config, lib, ... }:
let
  cfg = config.boot.preLVMTempMount;

  fsTypes = filesystems:
    lib.unique (lib.mapAttrsToList (_: opts: opts.fsType) filesystems);

  plural = filesystems:
    if builtins.length (builtins.attrNames filesystems) == 1
    then ""
    else "s";

  awaitingMsg = filesystems:
    "Waiting for temp mount filesystem${plural filesystems} to appear..";

  closingMsg = filesystems:
    "Closing temp mount filesystem${plural filesystems}...";

  awaitCondition = filesystems:
    lib.concatStringsSep " -o " (
      lib.mapAttrsToList (_: opts: "! -e ${opts.device}") filesystems
    );

  doMounting = filesystems:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (
          mountPoint: opts:
            ''
              mkdir -m 0755 -p "${mountPoint}"
              mount -n \
                -t ${opts.fsType} \
                -o ro \
                "${opts.device}" "${mountPoint}"
            ''
        )
        filesystems
    );

  cleanUp = filesystems:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList
        (
          mountPoint: _:
            ''
              umount "${mountPoint}"
              rmdir "${mountPoint}"
            ''
        )
        filesystems
    );
in
{
  options.boot.preLVMTempMount = lib.mkOption {
    description = ''
      An attrset containing descriptions of filesystems to temporarily mount
      before `preLVMCommands` run and unmount after they finish.
    '';
    default = null;
    type = lib.types.nullOr (
      lib.types.attrsOf (
        lib.types.submodule {
          options = {
            device = lib.mkOption {
              type = lib.types.str;
              description = "The path to the block device node.";
            };

            fsType = lib.mkOption {
              type = lib.types.str;
              description = "The type of filesystem used for the device.";
            };
          };
        }
      )
    );
  };

  config = lib.mkIf (cfg != null) {
    boot.initrd = {
      kernelModules = [ "loop" "usb_storage" ] ++ (fsTypes cfg);

      preLVMCommands = lib.mkMerge [
        (
          lib.mkBefore ''
            echo -n "${awaitingMsg cfg}"
            while [ ${awaitCondition cfg} ]
            do
              echo -n "."
              sleep 0.25
            done
            echo -n " done!"
            echo
            ${doMounting cfg}
          ''
        )

        (
          lib.mkAfter ''
            echo "${closingMsg cfg}"
            ${cleanUp cfg}
          ''
        )
      ];
    };
  };
}
