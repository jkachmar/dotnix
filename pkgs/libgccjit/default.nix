{ gcc }:

let
  patched = gcc.cc.overrideAttrs (_: { builder = ./builder.sh; });
in

# TODO: Remove this once the following PR is resolved/merged:
# https://github.com/NixOS/nixpkgs/pull/94637
patched.override {
  name = "libgccjit";
  langFortran = false;
  langCC = false;
  langC = false;
  profiledCompiler = false;
  langJit = true;
  enableLTO = false;
}
