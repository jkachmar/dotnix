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
      config = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    # ...along with the associated `pulseaudio` modules.
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
  };
  primary-user.persistence.home.sound = {
    directories = [
      ".config/pulse"
    ];
    files = [
      ".config/bluedevilglobalrc"
    ];
  };
}
