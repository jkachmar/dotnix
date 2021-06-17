# Hardware configuration.

{ config, lib, pkgs, modulesPath, ... }:
let
  # TODO: Replace this with the SD card.
  secure = "/dev/disk/by-label/secure";
in
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    # Lifted from github.com/nixos/nixos-hardware/blob/master/common/pc/ssd/default.nix
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];

    initrd = {
      # Kernel modules needed for mounting USB VFAT devices in 'initrd' stage.
      availableKernelModules = [ "ahci" "nvme" "rtsx_pci_sdmmc" "sd_mod" "usbhid" "xhci_pci" ];
      kernelModules = [ "dm-snapshot" "nls_cp437" "nls_iso8859_1" "usb_storage" "loop" "vfat" ];

      preLVMCommands = lib.mkMerge [
        (
          lib.mkBefore ''
            echo -n "Waiting for temp mount filesystem to appear.."
            while [ ! -e ${secure} ]
            do
              echo -n "."
              sleep 0.25
            done
            echo -n " done!"
            echo
            mkdir -m 0755 -p /key
            mount -n -t vfat -o ro ${secure} /key
          ''
        )
        (
          lib.mkAfter ''
            echo -n "Closing temp mount filesystem..."
            umount /key
            rmdir /key
          ''
        )
      ];

      luks.devices."crypt" = {
        device = "/dev/disk/by-id/nvme-Force_MP510_20338292000128874861-part2";
        header = "/key/enigma/crypt/header";
        keyFile = "/key/enigma/crypt/keyfile";
        preLVM = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/5612-A299";
      fsType = "vfat";
    };

    "/nix" = {
      device = "enigma/nix";
      fsType = "zfs";
    };

    "/secrets" = {
      device = "enigma/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/state" = {
      device = "enigma/state";
      fsType = "zfs";
      neededForBoot = true;
    };

    # NOTE: Logs are persisted within their own ZFS dataset to avoid being
    # included in the ZFS snapshots.
    #
    # `journalctl` (and presumably all other well-behaved application loggers)
    # will manage its own rotation, cleanup, etc. and ZFS shouldn't try to
    # duplicate this effort.
    "/state/logs" = {
      device = "enigma/state/logs";
      fsType = "zfs";
      neededForBoot = true;
    };

    # TODO: Permissions, fine-grained shares with the Synology, etc.
    "/mnt/moodyblues/media" = {
      device = "10.0.1.250:/volume1/media";
      fsType = "nfs";
      options = [ "ro" "auto" "defaults" "nfsvers=4.1" ];
    };

    # TODO: Permissions, fine-grained shares with the Synology, etc.
    "/mnt/moodyblues/downloads" = {
      device = "10.0.1.250:/volume1/downloads";
      fsType = "nfs";
      options = [ "auto" "defaults" "nfsvers=4.1" ];
    };
  };

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  swapDevices = [{ device = "/dev/disk/by-uuid/c3b6852d-41ac-4ee8-b9bd-bbaea1911512"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware = {
    cpu.intel.updateMicrocode = true;
    # High-resolution display.
    video.hidpi.enable = lib.mkDefault true;
  };
}
