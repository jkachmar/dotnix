{ ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";

    hostKeys = [
      {
        path = "/state/openssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/state/openssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
}
