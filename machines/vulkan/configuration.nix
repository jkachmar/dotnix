{ ... }:

{
  imports = [ ../../config/system/darwin.nix ];

  nix = {
    # You should generally set this to the total number of logical cores in your system
    # $ sysctl -n hw.ncpu
    buildCores = 12;
    maxJobs = 12;
  };
}
