{ ... }:

{
  imports = [ ../../config/system/darwin ];
  environment.darwinConfig = toString ./.;

  nix = {
    # You should generally set this to the total number of logical cores in your system
    # $ sysctl -n hw.ncpu
    buildCores = 4;
    maxJobs = 4;
  };
}
