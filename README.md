# I Fucking Hate Dotfiles

## Installation

Clone this repository to `$XDG_HOME_DIRECTORY/dotfiles` (i.e.
`$HOME/.config/dotfiles`); this is a hardcoded path, however it should be the
_only_ one that is expected by the configuration.

### Existing Profile

To install based off of a profile for an existing machine, symlink the machine
configuration directory to the repository root directory with the name
`current-machine`.

For example, to configure `crazy-diamond`, one would run the following command
in the root directory after a fresh clone of this repository:

```bash
ln -s ./machines/crazy-diamond ./current-machine
nix develop
nix build .#darwinConfigurations.crazy-diamond.system
./result/sw/bin/darwin-rebuild --flake $(pwd)#crazy-diamond switch
```

#### TODO

- [ ] package the above into a script available within the `nix develop` shell

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


### [`nix-direnv`]

This project contains a `.envrc` file that works with the [`nix-direnv`]
integration for [`direnv`]. This _should_ mean that, upon entering this
directory, a user is immediately dropped into the environment defined in this
repository's [`shell.nix`](./shell.nix) file.

Additionally, `nix-direnv` should also automatically register a [GC Root]
similar to [`lorri`]*.

Before running `nix-collect-garbage -d`, `nix-direnv`'s cached evaluation can be
"manually refreshed" by calling `touch .envrc` in this directory; this should
ensure that a GC Root is installed for an up-to-date version of `shell.nix`.

*I have a slight preference for `nix-direnv` over `lorri`
due to some issues I've had in the past with `lorri`'s daemon.

## Resources

TODO: Start linking to the stuff that helped me set this repository up in the
first place.

[`niv`]: https://www.github.com/nmattia/niv
[`nix-direnv`]: https://github.com/nix-community/nix-direnv
[`lorri`]: https://www.github.com/target/lorri
[`direnv`]: https://www.github.com/direnv/direnv
[GC Root]: https://nixos.org/nixos/nix-pills/garbage-collector.html#idm140737315973184
