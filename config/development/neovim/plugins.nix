{ lib, pkgs, ... }:
# TODO: Source this from a JSON file and write an update script.
#
# cf. The Plex Server 'update.sh'.
{
  everforest = pkgs.vimUtils.buildVimPlugin {
    name = "everforest";
    src = pkgs.fetchFromGitHub {
      owner = "sainnhe";
      repo = "everforest";
      rev = "bd9b29ab09c6475979af81c9505c405a55a8a00b";
      sha256 = "8GYzfdAbiecpVlE/R5lED3ucISYJ+aqhGmC/ePA24hc=";
    };
  };
  gruvbox-material = pkgs.vimUtils.buildVimPlugin {
    name = "gruvbox-material";
    src = pkgs.fetchFromGitHub {
      owner = "sainnhe";
      repo = "gruvbox-material";
      rev = "5cf1ae0742a24c73f29cbffc308c6f5576404e60";
      sha256 = "Gv68wgyrb9RSxRdgPHhvHciQY/umYfgByJ+nA3frKWM=";
    };
  };
  oceanic-next = pkgs.vimUtils.buildVimPlugin {
    name = "oceanic-next";
    src = pkgs.fetchFromGitHub {
      owner = "mhartington";
      repo = "oceanic-next";
      rev = "5ef31a34204f84714885ae9036f66a626036c3dc";
      sha256 = "AhF4v5bSvaSWDu4LL6Rm8+20/M0rd7/9pTUcrLpfX/E=";
    };
  };
}
