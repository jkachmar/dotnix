######################################
# macOS-specific dock configuration. #
######################################
{ ... }:

{
  system.defaults.dock = {
    autohide = true;
    orientation = "right";
    showhidden = true;
    tilesize = 48;
  };
}
