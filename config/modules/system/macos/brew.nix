############################################
# macOS "homebrew" configuration settings. #
############################################
{ ... }:

{
  homebrew = {
    enable = true;
    # NOTE: Allows `brew` to auto-update during `nix-darwin` activation; this
    # means that switching to a new profile is not _necessarily_ idempotent.
    autoUpdate = true;
    # NOTE: Uninstalls all formulas not listed in the generated `Brewfile`; if
    # the formula is a cask, removes all files associated with the cask.
    cleanup = "zap";
  };
}
