{ ... }:

{
  services.openssh = {
    enable = true;
    allowSFTP = false;
    challengeResponseAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "no";

    # Stealing some "paranoid" OpenSSH configuration options.
    #
    # cf. https://christine.website/blog/paranoid-nixos-2021-07-18
    extraConfig = ''
      AllowAgentForwarding yes
      AllowStreamLocalForwarding no
      AllowTcpForwarding yes
      AuthenticationMethods publickey
      X11Forwarding no
    '';

    hostKeys =  [
      {
        path = "/secrets/openssh/host/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "/secrets/openssh/host/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
    ];
  };
}
