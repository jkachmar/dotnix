# Hardware configuration.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    # Lifted from github.com/nixos/nixos-hardware/blob/master/common/pc/ssd/default.nix
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];

    # Temporary, read-only filesystem mounted before the LVM boot unit &
    # unmounted thereafter.
    preLVMTempMount."/key" = {
      device = "/dev/disk/by-label/secure";
      fsType = "vfat";
    };

    initrd = {
      # FIXME: Comment explaining why these modules were made available.
      availableKernelModules = [ "ahci" "nvme" "rtsx_pci_sdmmc" "sd_mod" "usbhid" "xhci_pci" ];
      # FIXME: Comment explaining why these modules were enabled.
      kernelModules = [ "dm-snapshot" "nls_cp437" "nls_iso8859_1" ];

      #####################
      # ENCRYPTED VOLUMES #
      #####################
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

    # Persistent '/home' state.
    "/home" = {
      device = "enigma/persist/home";
      fsType = "zfs";
    };

    # Persistent global state.
    "/persist" = {
      device = "enigma/persist/root";
      fsType = "zfs";
    };

    # Persistent podman containers.
    # 
    # NOTE: Symlinking this with 'systemd-tmpfiles' won't work since the ZFS
    # storage driver expects an actual ZFS dataset.
    "/persist/podman/containers" = {
      device = "enigma/persist/podman-containers";
      fsType = "zfs";
    };

    # 'systemd' logging.
    #
    # `journalctl` (and presumably all other well-behaved application loggers)
    # will manage its own rotation, cleanup, etc. and ZFS shouldn't try to
    # duplicate this effort.
    #
    # NOTE: Symlinking this with 'systemd-tmpfiles' won't work since there's
    # already an entry for '/var/log' present by default.
    "/var/log" = {
      device = "enigma/persist/systemd-logs";
      fsType = "zfs";
      neededForBoot = true;
    };

    # Large file download management.
    #
    # For the most part, anything that sits in these directories is expected to
    # be on this machine temporarily (in transit to 'moody-blues' or
    # elsewhere); snapshotting these sorts of files is a waste of space.
    "/persist/downloads" = {
      device = "enigma/persist/downloads";
      fsType = "zfs";
      neededForBoot = false;
    };

    # TODO: Permissions, fine-grained shares with the Synology, etc.
    "/mnt/moodyblues/media" = {
      device = "192.168.1.155:/volume1/media";
      fsType = "nfs";
      options = [ "auto" "defaults" "nfsvers=4.1" ];
    };

    # TODO: Permissions, fine-grained shares with the Synology, etc.
    "/mnt/moodyblues/downloads" = {
      device = "192.168.1.155:/volume1/downloads";
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

  swapDevices = [{ device = "/dev/mapper/system-swap"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware = {
    cpu.intel.updateMicrocode = true;
    # High-resolution display.
    video.hidpi.enable = lib.mkDefault true;
  };
}
