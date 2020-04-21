let
  nivSrc = fetchTarball {
    url = "https://github.com/nmattia/niv/tarball/f73bf8d584148677b01859677a63191c31911eae";
    sha256 = "0jlmrx633jvqrqlyhlzpvdrnim128gc81q5psz2lpp2af8p8q9qs";
  };
  sources = import "${nivSrc}/nix/sources.nix" {
    sourcesFile = ./sources.json;
  };
  niv = import nivSrc {};
in

niv // sources
