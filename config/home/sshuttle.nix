{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      sshuttle
    ];
  };
}
