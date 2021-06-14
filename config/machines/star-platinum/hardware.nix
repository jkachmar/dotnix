##########################
# HARDWARE CONFIGURATION #
##########################
{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  ########
  # BOOT #
  ########
  boot = {
    # FIXME: Comment where this is coming from.
    kernel.sysctl."vm.swappiness" = 1;
    # FIXME: Comment explaining `"sg"` module inclusion.
    kernelModules = [ "kvm-amd" "sg" ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "zfs" ];

    preLVMTempMount."/key" = {
      device = "/dev/disk/by-label/secure";
      fsType = "vfat";
    };

    initrd = {
      # FIXME: Comment explaining why these modules were made available;
      availableKernelModules = [ "ahci" "nvme" "sd_mod" "usbhid" "xhci_pci" ];
      # FIXME: Comment explaining why these modules were enabled.
      kernelModules = [ "dm-snapshot" "nls_cp437" "nls_iso8859_1" ];

      #####################
      # ENCRYPTED VOLUMES #
      #####################
      luks.devices."crypt" = {
        device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_500GB_S62ANJ0NC37730N-part1";
        header = "/key/star-platinum/crypt/header";
        keyFile = "/key/star-platinum/crypt/keyfile";
        preLVM = true;
      };

      luks.devices."cryptswap" = {
        device = "/dev/disk/by-id/nvme-ADATA_SX8200PNP_2J2220006023-part3";
        header = "/key/star-platinum/cryptswap/header";
        keyFile = "/key/star-platinum/cryptswap/keyfile";
        preLVM = true;
      };
    };
  };

  ###############
  # FILESYSTEMS #
  ###############
  fileSystems."/" =
    {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/663E-74F0";
      fsType = "vfat";
    };

  # Nix store.
  fileSystems."/nix" =
    {
      device = "star-platinum/nix";
      fsType = "zfs";
    };

  # NixOS configuration.
  fileSystems."/state" =
    {
      device = "star-platinum/state";
      fsType = "zfs";
      neededForBoot = true;
    };

  services.zfs = {
    trim.enable = true;
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";
    };
  };

  # TODO: Find a way to link this 
  swapDevices = [ { device = "/dev/mapper/cryptswap"; } ];

  ##################
  # NVIDIA Support #
  ##################
  # XXX: Update once 21.05 lands:
  #
  #   hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  #   services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  services.xserver.videoDrivers = [ "nvidia" ];
  primary-user.persistence.home.nvidia.directories = [ ".nv" ];

  ##################
  # MISC. HARDWARE #
  ##################
  hardware = {
    cpu.amd.updateMicrocode = true;
    # High-resolution display support
    video.hidpi.enable = lib.mkDefault true;
  };

  # TODO: Check with others on what makes for good tuning here...
  #
  # For now:
  #   - 4x maxJobs = up to 4 derivations may be built in parallel
  #   - 3x buildCores = each derivation will be given 3 cores to work with 
  nix = {
    buildCores = lib.mkDefault 3;
    maxJobs = lib.mkDefault 4;
  };
}
