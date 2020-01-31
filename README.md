# I Fucking Hate Dotfiles

## Installation

To install the default profile (callisto), ensure Nix is installed and
available (multi-user with daemon) and run the following:

```bash
nix-shell --run "switch-all"
```

To install another profile, ensure that valid `configuration.nix` and `home.nix`
files (to configure the NixOS or `nix-darwin` system and `home-manager`
settings, respectively) are present in a directory named after the
machine-to -be-configured under `./machines`, and pass the machine name as
an argument to the `nix-shell`, as follows (e.g. for `thetis`):

```bash
nix-shell --argstr "machine" "thetis" --run "switch-all"
```

## Maintenance

### Updating

The pinned sources tracked in `./nix/sources.json` are managed with [`niv`],
and can be updated as follows:

```bash
nix-shell --run "niv update"
```

The next time a `nix-shell` is entered, or any of the scripts defined in
`shell.nix` are run, the new sources will be pulled from.


### [`lorri`]

This project contains a `.envrc` file that will trigger [`lorri`] via
[`direnv`]. This _should_ mean that any changes that would modify the Nix
environment will be evaluated and cached as a [GC Root] thanks to the `lorri`
daemon running in the background.

Just in case, `lorri --watch-once` can be used to make sure everything's
buttoned up before running `nix-collect-garbage -d` to clear out unused
dependencies and free up space.

## Resources

TODO: Start linking to the stuff that helped me set this repository up in the
first place.

[`niv`]: https://www.github.com/nmattia/niv
[`lorri`]: https://www.gitub.com/target/lorri
[`direnv`]: https://www.gitub.com/direnv/direnv
[GC Root]: https://nixos.org/nixos/nix-pills/garbage-collector.html#idm140737315973184
