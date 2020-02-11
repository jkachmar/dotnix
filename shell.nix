{ machine ? "callisto" }:


let
  sources = import ./nix/sources.nix;
  nixpkgs = sources.nixpkgs-darwin;
  darwin = sources.nix-darwin;
  home-manager = sources.home-manager;
  unstable = import sources.nixpkgs-unstable {};

in
  with (import nixpkgs {});
  let
    #####################################
    darwin-config = "./machines/${machine}/configuration.nix";
    home-manager-config = "./machines/${machine}/home.nix";

    build-nix-path-env-var = path:
      builtins.concatStringsSep ":" (
        pkgs.lib.mapAttrsToList (k: v: "${k}=${v}") path
      );

    nix-path = build-nix-path-env-var {
      inherit
        darwin
        darwin-config
        home-manager
        nixpkgs
        ;
    };

    #####################################

    darwin-rebuild-bin = pkgs.writeShellScriptBin "darwin-rebuild" ''
      export NIX_PATH="${nix-path}"
      $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild $@
    '';

    darwin-switch = pkgs.writeShellScriptBin "darwin-switch" ''
      darwin-rebuild switch
    '';

    #####################################

    home-manager-bin = pkgs.writeShellScriptBin "home-manager" ''
      export NIX_PATH="${nix-path}"
      $(nix-build '<home-manager>' -A home-manager --no-out-link)/bin/home-manager $@
    '';

    home-switch = pkgs.writeShellScriptBin "home-switch" ''
      home-manager -f "${home-manager-config}" switch
    '';

    #####################################

    files = "$(find . -name '*.nix' -not -wholename './nix/sources.nix')";

    lint = pkgs.writeShellScriptBin "lint" "nix-linter ${files}";

    format = pkgs.writeShellScriptBin "format" "nixpkgs-fmt ${files}";

    #####################################

    switch-all = pkgs.writeShellScriptBin "switch-all" ''
      set -e
      lint
      format

      darwin-switch
      home-switch
    '';

  in
    mkShell {
      buildInputs = [
        # Newer version of niv that should still be cached
        unstable.niv

        # darwin rebuild script and switch util
        darwin-rebuild-bin
        darwin-switch

        # home-manager activation script and switch util
        home-manager-bin
        home-switch

        # Utils for lintinga nd formatting nix files in this repo
        unstable.nix-linter
        lint
        unstable.nixpkgs-fmt
        format

        # System (i.e. darwin && home-manager) switch util
        switch-all
      ];
    }
