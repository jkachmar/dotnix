{ lib, ... }:

{
  # TODO: Check with others on what makes for good tuning here...
  #
  # For now:
  #   - 2x maxJobs = up to 2 derivations may be built in parallel
  #   - 2x buildCores = each derivation will be given 2 cores to work with 
  nix = {
    buildCores = lib.mkDefault 2;
    maxJobs = lib.mkDefault 2;
  };
}
