{ lib
, fetchFromGitHub
  # Upstream derivation to override.
, emacsDrv
  # Dependencies.
, Cocoa
, gmp
, gnused
  # Options.
, withDbus ? false
, dbus
, withDebug ? false
, withGnuTLS ? true
, withNoTitlebar ? false
, withXML ? true
, libxml2
  # macOS version options.
, withMojave ? false
}:
let
  pname = "emacs-plus";
  version = emacsDrv.version;
  # XXX: Switch this back when not building emacs from git.
  majorVersion = "28";
  # majorVersion = lib.head (lib.splitString "." version);

  # Used to source and select up-to-date patches.
  emacsPlusSrc = fetchFromGitHub {
    owner = "d12frosted";
    repo = "homebrew-emacs-plus";
    rev = "b6a1d5306afdd3a5b15a0ae6a5d8b3d050575d14";
    sha256 = "1llkmfnhmc3jlp1m2bvpw374y7hmxnrhzjdm2d8l57bnj1fd0v7c";
  };
  emacsPlusPatches = "${emacsPlusSrc}/patches/emacs-${majorVersion}";
in
(emacsDrv.override { withNS = true; }).overrideAttrs (
  old: {
    inherit pname version;

    patches = (old.patches or [ ]) ++ [
      "${emacsPlusPatches}/fix-window-role.patch"
      "${emacsPlusPatches}/system-appearance.patch"
    ] ++ lib.optional withNoTitlebar "${emacsPlusPatches}/no-titlebar.patch";

    postPatch = "rm -fr .git";

    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ gnused ];
    buildInputs = (old.buildInputs or [ ]) ++ [ Cocoa gmp ]
      ++ lib.optional withDbus dbus
      ++ lib.optional withXML libxml2;

    makeFlags = (old.makeFlags or [ ]) ++ [ "NATIVE_FAST_BOOT=1" ];

    configureFlags = (old.configureFlags or [ ]) ++ [
      (if withDbus then "--with-dbus" else "--without-dbus")
    ]
      ++ lib.optional withGnuTLS "--with-gnutls"
      ++ lib.optional withXML "--with-xml2";

    CFLAGS = (old.CFLAGS or "") + (
      if withDebug
      then "-g -Og"
      else "-O3"
    );

    LDFLAGS = (old.LDFLAGS or "") + (
      if withDebug
      then "-g -Og"
      else "-O3"
    );

    # Disable aligned_alloc on Mojave.
    #
    # See issue: https://github.com/daviderestivo/homebrew-emacs-head/issues/15
    postConfigure = lib.optional withMojave ''
      substituteInPlace src/config.h \
        --replace "#define HAVE_ALIGNED_ALLOC 1" "#undef HAVE_ALIGNED_ALLOC" \
        --replace "#define HAVE_DECL_ALIGNED_ALLOC 1" "#undef HAVE_DECL_ALIGNED_ALLOC" \
        --replace "#define HAVE_ALLOCA 1" "#undef HAVE_ALLOCA" \
        --replace "#define HAVE_ALLOCA_H 1" "#undef HAVE_ALLOCA_H"
    '';
  }
)
