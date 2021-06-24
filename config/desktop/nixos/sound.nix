#####################################
# NixOS system sound configuration. #
#####################################
{ pkgs, ... }:
{
  sound.enable = true;
  hardware = {
    # Enable bluetooth...
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    # ...along with the associated `pulseaudio` modules.
    pulseaudio = {
      enable = true;
      support32Bit = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      # XXX The Blue Yeti stereo output fails without this.
      #
      # cf. https://askubuntu.com/questions/1255276/yeti-nano-flashes-yellow-in-ubuntu-studio-20-04
      daemon.config = {
        default-sample-rate = 48000;
      };
    };
  };
}
