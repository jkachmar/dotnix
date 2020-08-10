{ stdenv
, lib
, fetchFromGitHub
  # Native dependencies.
, autoconf
, automake
, pkgconfig
, texinfo
  # General dependencies.
, gettext
, gnused
, gmp
, harfbuzz
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
, withImageMagick ? true
, withJSON ? true
, jansson
, withNativeComp ? false
, binutils
, binutils-unwrapped
, gcc
, makeWrapper
, targetPlatform
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
  version = "28.0.50";
  majorVersion = lib.head (lib.splitString "." version);

  # NOTE: Uncomment when not on native comp branch. 
  # emacsName = "emacs-${version}";

  # Used to source and select up-to-date patches.
  emacsPlusSrc = fetchFromGitHub {
    owner = "d12frosted";
    repo = "homebrew-emacs-plus";
    rev = "b6a1d5306afdd3a5b15a0ae6a5d8b3d050575d14";
    sha256 = "1llkmfnhmc3jlp1m2bvpw374y7hmxnrhzjdm2d8l57bnj1fd0v7c";
  };
  emacsPlusPatches = "${emacsPlusSrc}/patches/emacs-${majorVersion}";

  libgccjit = gcc.cc.overrideAttrs (
    _: {
      langFortran = false;
      langCC = false;
      langC = false;
      profiledCompiler = false;
      langJit = true;
      enableLTO = false;
      builder = ./gcc-builder.sh;
    }
  );

in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    # NOTE: feature/native-comp
    owner = "emacs-mirror";
    repo = "emacs";
    rev = "dd814b0a58aebe12168ffde946860e851ecf2b5b";
    sha256 = "0b7lwlpav73q7misvlsp9d9w4vbjfpfka780is1s81jwrsvww24y";

    # NOTE: 27.1-rc2
    # rev = "tags/${emacsName}";
    # sha256 = "1i50ksf96fxa3ymdb1irpc82vi67861sr4xlcmh9f64qw9imm3ks";
  };

  enableParallelBuilding = true;

  patches = [
    ./patches/emacs-28/clean-env.patch # From nixpkgs.
    "${emacsPlusPatches}/fix-window-role.patch"
    "${emacsPlusPatches}/system-appearance.patch"
  ] ++ lib.optional withNoTitlebar "${emacsPlusPatches}/no-titlebar.patch"

  # TODO: Remove this once the following PR is resolved/merged:
  # https://github.com/NixOS/nixpkgs/pull/94637
  #
  # Patch extracted from the following branch:
  # https://github.com/emacs-mirror/emacs/compare/feature/native-comp...antifuchs:allow-setting-driver-options
  #
  # ...which I found on the following mailing list thread:
  # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=42761
  ++ lib.optional withNativeComp "${emacsPlusPatches}/native-comp.patch";

  postPatch = lib.concatStringsSep "\n" [
    # Make native compilation work both inside and outside of nix build
    (
      lib.optionalString withNativeComp (
        let
          libPath = lib.concatStringsSep ":" [
            "${libgccjit}/lib/gcc/${targetPlatform.config}/${libgccjit.version}"
            "${lib.getLib stdenv.cc.cc}/lib"
            "${lib.getLib stdenv.libc}/lib"
          ];
        in
          ''
            substituteInPlace lisp/emacs-lisp/comp.el --replace \
              "(defcustom comp-async-env-modifier-form nil" \
              "(defcustom comp-async-env-modifier-form '((setenv \"LIBRARY_PATH\" (string-join (seq-filter (lambda (v) (null (eq v nil))) (list (getenv \"LIBRARY_PATH\") \"${libPath}\")) \":\")))"
          ''
      )
    )

    "rm -fr .git"
  ];

  nativeBuildInputs = [ autoconf automake gnused makeWrapper pkgconfig ];
  buildInputs = [ AppKit Cocoa gettext gmp GSS harfbuzz.dev ImageIO IOKit ncurses texinfo ]
  ++ lib.optional withDbus dbus
  ++ lib.optional withGnuTLS gnutls
  ++ lib.optionals withImageMagick [ imagemagick librsvg ]
  ++ lib.optional withJSON jansson
  ++ lib.optional withNativeComp libgccjit
  ++ lib.optional withXML libxml2;

  makeFlags = [ "NATIVE_FAST_BOOT=1" ];

  configureFlags = [
    "--with-ns"
    "--disable-ns-self-contained"
    "--with-rsvg"
    (if withDbus then "--with-dbus" else "--without-dbus")
  ]
  ++ lib.optional withGnuTLS "--with-gnutls"
  ++ lib.optional withJSON "--with-json"
  ++ lib.optional withNativeComp "--with-nativecomp"
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

  LIBRARY_PATH = if withNativeComp
  then "${lib.getLib stdenv.cc.libc}/lib"
  else "";

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

    $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

    siteVersionDir=`ls $out/share/emacs | grep -v site-lisp | head -n 1`

    rm -rf $out/var
    rm -rf $siteVersionDir

    mkdir -p $out/Applications
    mv nextstep/Emacs.app $out/Applications
  '';

  # TODO: Verify that this is necessary.
  postFixup = lib.concatStringsSep "\n" [
    (
      lib.optionalString withNativeComp ''
        wrapProgram $out/bin/emacs-* --prefix PATH : "${lib.makeBinPath [ binutils binutils-unwrapped ]}"
      ''
    )
  ];

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
