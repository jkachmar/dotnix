# I Fucking Hate Dotfiles

## Installation

Clone this repository to `$XDG_HOME_DIRECTORY/dotfiles` (i.e.
`$HOME/.config/dotfiles`); this is a hardcoded path, however it should be the
_only_ one that is expected by the configuration.

### Existing Profile

To install based off of a profile for an existing machine, symlink the machine
configuration directory to the repository root directory with the name
`current-machine`.

For example, to configure `star-platinum`, one would run the following command
in the root directory after a fresh clone of this repository:

```bash
ln -s ./machines/star-platinum ./current-machine
nix-shell --run rebuild
```

### New Profile

To install based off of a new profile:

* create a new directory with the machine name at `machines/<new-machine-name>`
* perform the same steps as above to build and deploy the new machine's
configuration

### Post-Install

Once everything's been installed and is up and running, `direnv allow` will
enable `lorri` and most of the `nix-shell --run` nonsense below can be elided.

## Maintenance

### Updates

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
