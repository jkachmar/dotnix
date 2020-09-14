{ ... }:

{
  # This should generally be set to machine's number of logical cores.
  nix = {
    buildCores = 4;
    maxJobs = 4;
  };
}
