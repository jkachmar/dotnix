{ lib
, stdenv
, plexRaw
, fetchurl
}:
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  source = lib.findFirst
    (x: x.platform == stdenv.hostPlatform.system)
    (throw "unsupported platform: ${stdenv.hostPlatform.system}")
    sources;
in
plexRaw.overrideAttrs (attrs: rec {
  pname = attrs.pname + "-plexpass";
  version = source.version;
  src = fetchurl {
    inherit (source) url;
    sha256 = source.hash;
  };
})
