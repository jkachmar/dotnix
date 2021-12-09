{ lib, ... }:

{
  # TODO: Check with others on what makes for good tuning here, especially on M1 machines.
  #
  # For now:
  #   - 4x maxJobs = up to 4 derivations may be built in parallel
  #   - 2x buildCores = each derivation will be given 2 cores to work with 
  nix = {
    buildCores = lib.mkDefault 2;
    maxJobs = lib.mkDefault 4;
  };
}
