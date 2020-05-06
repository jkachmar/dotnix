{ ... }:

{
  # This should generally be set to machine's number of logical cores.
  #
  # When in doubt, check by running sysctl -n hw.ncpu
  nix = {
    buildCores = 16;
    maxJobs = 16;
  };
}
