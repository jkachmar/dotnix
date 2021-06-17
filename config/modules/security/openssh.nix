{ ... }:

{
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";

    # TODO: Consider unifying this to use the '/secrets' (cf. enigma).
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
