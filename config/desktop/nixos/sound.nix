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
      # https://wiki.archlinux.org/title/Bluetooth_headset#Apple_AirPods_have_low_volume
      disabledPlugins = [ "avrcp" ];
      settings = {
        General = {
          ControllerMode = "bredr"; # NOTE: Need this to connect to AirPods.
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    # ...along with the associated `pulseaudio` modules.
    pulseaudio = {
      enable = true;
      support32Bit = true;
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
