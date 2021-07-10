###################################
# NixOS X11 server configuration. #
###################################
{ ... }:

{
  # Install and enable Vulkan.
  # 
  # https://nixos.org/manual/nixos/unstable/index.html#sec-gpu-accel
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # XXX: Only if using Intel graphics.
    # extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];  

    driSupport32Bit = true;
    # XXX: Only if using Intel graphics.
    # extraPackages32 = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];  
  };

  # Enable X11 + Nvidia
  # https://nixos.org/manual/nixos/unstable/index.html#sec-gnome-gdm
  services.xserver = {
    enable = true;
    layout = "us";

    # TODO: Verify that this is necessary.
    # TODO: This isn't machine-agnostic.
    videoDrivers = [ "nvidia" ]; 
  };
}