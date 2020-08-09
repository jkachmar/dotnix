{ stdenv
, lib
, fetchurl
, fetchFromGitHub
  # Native dependencies.
, autoconf
, automake
, pkgconfig
, texinfo
  # General dependencies.
, gettext
, gmp
, librsvg
, ncurses
  # Darwin-specific dependencies.
, AppKit
, Cocoa
, GSS
, ImageIO
, IOKit
  # Options.
, withDbus ? false
, dbus
, withDebug ? false
, withGnuTLS ? true
, gnutls
, withJSON ? true
, jansson
, withImageMagick ? true
, withNoTitlebar ? false
, withXML ? true
, libxml2
, imagemagick
  # macOS version options.
, withMojave ? false
  # Misc. paths and/or other configuration options.
, siteStart ? ./site-start.el
}:

let
  pname = "emacs-plus";
  version = "27.1-rc2";
  emacsName = "emacs-${version}";
  majorVersion = lib.head (lib.splitString "." version);

  # Used to source and select up-to-date patches.
  emacsPlusSrc = fetchFromGitHub {
    owner = "d12frosted";
    repo = "homebrew-emacs-plus";
    rev = "b6a1d5306afdd3a5b15a0ae6a5d8b3d050575d14";
    sha256 = "1llkmfnhmc3jlp1m2bvpw374y7hmxnrhzjdm2d8l57bnj1fd0v7c";
  };
  patchDir = "${emacsPlusSrc}/patches/emacs-${majorVersion}";

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/emacs/pretest/${emacsName}.tar.xz";
    sha256 = "0h9f2wpmp6rb5rfwvqwv1ia1nw86h74p7hnz3vb3gjazj67i4k2a";
  };

  enableParallelBuilding = true;

  patches = [
    ./clean-env.patch # From nixpkgs.
    "${patchDir}/fix-window-role.patch"
    "${patchDir}/system-appearance.patch"
  ] ++ lib.optional withNoTitlebar "${patchDir}/no-titlebar.patch";

  postPatch = "rm -fr .git";

  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ AppKit Cocoa gettext gmp GSS ImageIO IOKit ncurses texinfo ]
  ++ lib.optional withDbus dbus
  ++ lib.optional withGnuTLS gnutls
  ++ lib.optional withJSON jansson
  ++ lib.optional withXML libxml2
  ++ lib.optionals withImageMagick [ imagemagick librsvg ];

  configureFlags = [
    (if withDbus then "--with-dbus" else "--without-dbus")
  ]
  ++ lib.optional withGnuTLS "--with-gnutls"
  ++ lib.optional withJSON "--with-json"
  ++ lib.optional withXML "--with-xml2";

  CFLAGS = "-DMAC_OS_X_VERSION_MAX_ALLOWED=101200" + (
    if withDebug
    then "-g -Og"
    else "-O3"
  );

  LDFLAGS = "-L${ncurses.out}/lib" + (
    if withDebug
    then "-g -Og"
    else "-O3"
  );

  preConfigure = ''
    ./autogen.sh

    substituteInPlace lisp/international/mule-cmds.el \
      --replace /usr/share/locale ${gettext}/share/locale

    for makefile_in in $(find . -name Makefile.in -print); do
        substituteInPlace $makefile_in --replace /bin/pwd pwd
    done
  '';

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

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/
    cp ${siteStart} $out/share/emacs/site-lisp/site-start.el

    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  # TODO: Verify that this is necessary.
  postFixup = ''
    rm -rf $out/bin/ctags
  '';

  meta = with stdenv.lib; {
    description = "The extensible, customizable GNU text editor";
    homepage = "https://www.gnu.org/software/emacs/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.darwin;

    longDescription = ''
      GNU Emacs is an extensible, customizable text editor—and more.  At its
      core is an interpreter for Emacs Lisp, a dialect of the Lisp
      programming language with extensions to support text editing.
      The features of GNU Emacs include: content-sensitive editing modes,
      including syntax coloring, for a wide variety of file types including
      plain text, source code, and HTML; complete built-in documentation,
      including a tutorial for new users; full Unicode support for nearly all
      human languages and their scripts; highly customizable, using Emacs
      Lisp code or a graphical interface; a large number of extensions that
      add other functionality, including a project planner, mail and news
      reader, debugger interface, calendar, and more.  Many of these
      extensions are distributed with GNU Emacs; others are available
      separately.
    '';
  };
}
