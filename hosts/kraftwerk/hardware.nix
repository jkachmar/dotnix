###########################
# Hardware Configuration. #
###########################
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  #########
  # Boot. #
  #########
  boot = {
    kernel.sysctl."vm.swappiness" = 1;
    kernelPackages = pkgs.linuxPackages_5_14;
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];

    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usbhid"
        "usb_storage"
        "xhci_pci"
      ];
      kernelModules = [
        "dm-snapshot"
        "nls_cp437"
        "nls-iso8859_1"
      ];
    };

    ####################
    # Disk Encryption. #
    ####################
    preLVMTempMount."/key" = {
      device = "/dev/disk/by-label/secure";
      fsType = "vfat";
    };

    initrd.luks.devices = {
      "crypt" = {
        device = "/dev/nvme0n1p2";
        header = "/key/kraftwerk/crypt/header";
        keyFile = "/key/kraftwerk/crypt/keyfile";
        preLVM = true;
      };
    };
  };

  ##########################
  # Filesystem Management. #
  ##########################
  fileSystems = {
    # Boot partition.
    "/boot" = {
      device = "/dev/disk/by-uuid/F3D6-6687";
      fsType = "vfat";
    };

    # Ephemeral root partition.
    "/" = {
      device = "none";
      fsType = "tmpfs";
    };

    # Nix store.
    "/nix" = {
      device = "kraftwerk/nix";
      fsType = "zfs";
    };

    # Persistent `/home` directory.
    "/home" = {
      device = "kraftwerk/persist/home";
      fsType = "zfs";
    };

    # Persistent global state.
    "/persist" = {
      device = "kraftwerk/persist/root";
      fsType = "zfs";
    };

    # Local secrets.
    "/secrets" = {
      device = "kraftwerk/secrets";
      fsType = "zfs";
      neededForBoot = true;
    };

    # systemd-logging.
    "/var/log" = {
      device = "kraftwerk/persist/systemd-logs";
      fsType = "zfs";
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

  swapDevices = [ { device = "/dev/mapper/system-swap"; } ];

  ##################
  # Miscellaneous. #
  ##################

  # TODO: Verify that this is tuned "properly".
  #
  # For now:
  #   - 2x buildCores = each derivation will be given 2 cores to work with.
  #   - 4x maxJobs = up to 4 derivations will ber built in parallel.
  nix = {
    buildCores = lib.mkDefault 2;
    maxJobs = lib.mkDefault 4;
  };

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    # NOTE: When 21.11 lands, swap for:
    # wirelessRegulatoryDatabase = true;
    firmware = [ pkgs.wireless-regdb ];

    cpu.intel.updateMicrocode = true;
    video.hidpi.enable = lib.mkDefault true;
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
