# 
{ pkgs, ... }:
{
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      # Hardware transcoding.
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      libvdpau-va-gl
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but can work better for some applications)
      vaapiVdpau
      # HDR tone mapping.
      beignet
      intel-compute-runtime
      ocl-icd
    ];
    # 32-bit support.
    driSupport32Bit = true;
    extraPackages32 = with pkgs; [
      # Hardware transcoding.
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      libvdpau-va-gl
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but can work better for some applications)
      vaapiVdpau
      # HDR tone mapping.
      beignet
      intel-compute-runtime
      ocl-icd
    ];
  };
}
