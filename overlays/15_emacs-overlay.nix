# XXX: Nix seems to have trouble when importing an overlay directly from Niv's
# "../nix/sources.nix" file.
#
# The relative path seems to mess it up, with the following message:
#
# error: getting status of '/nix/store/nix/sources.nix': No such file or directory
let
  owner = "nix-community";
  repo = "emacs-overlay";
  rev = "b5b63076de639b23561c1a6de6f0c79da44b0857";
  sha256 = "0pv525dy8cxgbh06l0llsxy77j7ka8f10gz3p65nbrc3111v72rl";
in

import (
  builtins.fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    inherit sha256;
  }
)
