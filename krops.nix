{ darwin, lib, writeCommand }:
let
  source = name: lib.evalSource [{
    # # TODO: Figure out secrets using `pass` CLI & `gpg-agent`.
    # secrets.pass = {
    #   dir = toString /home/jkachmar/.local/share/password-store/secrets;
    #   name = name;
    # };

    # Copy the entire repo over to `/var/src` on the target machine.
    #
    # By default, `nixos-rebuild` and `darwin-rebuild` will use the target
    # system's hostname to look up the configuration in `nixosConfigurations`
    # or `darwinConfigurations` (respectively) within `flake.nix`.
    #
    # TODO: Figure out if the hostname stuff above is fine, or if the machine
    # should be explicitly specified in the generated deployment scripts.
    dotfiles.file = {
      path = toString ./.;
      useChecksum = true;
    };
  }];

  # XXX: Sometimes services fail to switch on the first run, but are fine on
  # the second...
  nixOSCommand = targetPath: ''
    nix-shell -p git --run '
      nixos-rebuild switch --verbose --show-trace --flake ${targetPath}/dotfiles || \
        nixos-rebuild switch --verbose --show-trace --flake ${targetPath}/dotfiles
    '
  '';

  # TODO: Finish documenting wtf is going on here... 
  #
  # FIXME: This is awful, you can do better!
  macOSCommand = name: targetPath: ''
    nix build --no-link ${targetPath}/dotfiles#darwinConfigurations.${name}.system
    RESULT=$(nix path-info /Users/jkachmar/.config/dotfiles/#darwinConfigurations.${name}.system)
    $RESULT/sw/bin/darwin-rebuild \
      --flake ${targetPath}/dotfiles#${name} \
      -I darwin=${darwin} \
      -I darwin-config=${targetPath}/dotfiles/machines/${name} \
      switch
  '';

  # Convenience function to define generic deployment derivations.
  createHost = command: name: target:
    writeCommand "deploy-${name}" {
      inherit command;
      source = source name;
      target = (lib.mkTarget target) // {
        extraOptions = [ "-A" ];
        sudo = true;
      };
    };

  # Convenience function to create a macOS host.
  createHostMacOS = name:
    let command = macOSCommand name;
    in createHost command name;

  # Convenience function to create a NixOS host.
  createHostNixOS = createHost nixOSCommand;

in
{
  # TODO: Set up hosts file so that `crazy-diamond` recognizes itself as
  # localhost, but other machines see it as its absolute IP address.
  crazy-diamond = createHostMacOS "crazy-diamond" "jkachmar@localhost";
}
