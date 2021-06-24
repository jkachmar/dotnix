{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    kernel.sysctl."vm.swappiness" = 1;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ "dm-snapshot" ];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };

    ###########################################################################
    # Encrypted volume management.
    ###########################################################################
    preLVMTempMount."/key" = {
      device = "/dev/disk/by-label/secure";
      fsType = "vfat";
    };

    boot.initrd.luks.devices = {
      "crypt" = {
        device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S62ANJ0NC37730N-part1";
        header = "/key/star-platinum/crypt/header";
        keyFile = "/key/star-platinum/crypt/keyfile";
        preLVM = true;
      };

      "cryptswap" = {
        device = "/dev/disk/by-id/nvme-ADATA_SX8200PNP_2J2220006023-part3";
        header = "/key/star-platinum/cryptswap/header";
        keyFile = "/key/star-platinum/cryptswap/keyfile";
        preLVM = true;
      };
    };
  };

  #############################################################################
  # Filesystems.
  #############################################################################
  fileSystems = {
    # Boot partition.
    "/boot" = {
      device = "/dev/disk/by-uuid/663E-74F0";
      fsType = "vfat";
    };

    # Ephermeral root partition.
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

    # Nix store.
    "/nix" = {
      device = "star-platinum/nix";
      fsType = "zfs";
    };

    # [OLD] Persistent state.
    "/state" = {
      device = "star-platinum/state";
      fsType = "zfs";
      neededForBoot = true;
    };

    # # [NEW] Persistent '/home' state.
    # "/home" = {
    #   device = "star-platinum/persist/home";
    #   fsType = "zfs";
    # };

    # [NEW] Persistent global state.
    "/persist" = {
      device = "star-platinum/persist/root";
      fsType = "zfs";
    };

    # [NEW] Local secret storage; sometimes needed for boot.
    "/secrets" = {
      device = "star-platinum/persist/secrets";
      fsType = "zfs";
      neededForBoot = true;
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

  #############################################################################
  # NVIDIA
  #############################################################################
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  services.xserver.videoDrivers = [ "nvidia" ];

  # TODO: Check with others on what makes for good tuning here...
  #
  # For now:
  #   - 4x maxJobs = up to 4 derivations may be built in parallel
  #   - 3x buildCores = each derivation will be given 3 cores to work with 
  nix = {
    buildCores = lib.mkDefault 3;
    maxJobs = lib.mkDefault 4;
  };

  #############################################################################
  # Misc. other hardware settings (microcode updates, DPI, etc.)  
  #############################################################################
  hardware = {
    cpu.amd.updateMicrocode = true;
    video.hidpi.enable = lib.mkDefault = true;
  };
}
