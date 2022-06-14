#####################################
# NixOS system sound configuration. #
#####################################
{ pkgs, ... }:
{

  # Ensure that any relevant stateful files are persisted across reboots.
  #
  # NOTE: Symlinking (with 'systemd.tmpfiles.rules') doesn't work here, but a
  # bind-mount to the persistent storage location does the trick.
  fileSystems."/var/lib/bluetooth" = {
    device = "/persist/var/lib/bluetooth";
    options = [ "bind" ];
  };

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
