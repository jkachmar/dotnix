{ ... }:

{
  primary-user.home-manager.programs.ssh = {
    enable = true;
    userKnownHostsFile = "/secrets/openssh/client/jkachmar/known_hosts";
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = ["/secrets/ssh/jkachmar/id_github"];
      };
    };
  };
}
