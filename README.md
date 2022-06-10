# I Fucking Hate Dotfiles

## Installation

### Clone

#### macOS

Clone this repository to `$HOME/.config/dotfiles`; this is a hardcoded path,
however it should be the _only_ one that is expected by the configuration.

After cloning, `cd` into the directory.

#### NixOS

The system-level prerequisites of the NixOS configuration is significantly more
involved than the macOS configuration.

In general it follows the same principles as [Graham Christensen] described in
his [Erase Your Darlings] blog post; in this case, `/persist` is being used as
the persistent directory.

This repository can be cloned anywhere, but in general I tend to place it in
`$HOME/.config/dotfiles` on desktop machines and `/persist/etc/nixos` on servers.

After cloning, `cd` into the directory.

### Existing Profile

#### macOS

From the configuration directory, build the darwin activation utilities and
then invoke them directly for the desired profile.

For example, the following will build and activate the `crazy-diamond` profile:

```bash
nix build .#darwinConfigurations.crazy-diamond.system
./result/sw/bin/darwin-rebuild --flake $(pwd)#crazy-diamond switch
```

At the time of writing, `nix-darwin` hasn't been fully updated to work with
Flakes so this will have to be repeated every time the configuration is to be
updated.

##### TODO

- [ ] package the above into a script available within the `nix develop` shell

#### NixOS

From the configuration directory, build the NixOS configuration and activate
it.

For example, the following will build and activate the `star-platinum` profile:

```bash
nixos-rebuild switch \
  --use-remote-sudo \
  --flake '.#star-platinum'
```

The initial activation will set the machine's host name, which means that
subsequent activations can be performed with `nixos-rebuild switch --use-remote-sudo`.

**NOTE**: `--use-remote-sudo` is a "workaround" for how flakes repositories can interact
with `git-2.35.`.

cf. https://github.com/NixOS/nixpkgs/issues/169193

### New Profile

To install based off of a new profile:

* create a new directory with the machine name at `machines/<new-machine-name>`
* perform the same steps as above to build and deploy the new machine's
configuration

### Post-Install

Once everything's been installed and is up and running, `direnv allow` will
enable `nix-direnv` and most of the `nix-shell --run` nonsense below can be
elided.

## Maintenance

### Updates

Sources are pinned and tracked using "Nix Flakes".

#### TODO

- [ ] add example commands showing how to update pinned flake sources.

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

**TODO**: Link against some of the Nix configurations that I referenced when
figuring this out for myself.

[Graham Christensen]: https://github.com/grahamc
[Erase Your Darlings]: https://grahamc.com/blog/erase-your-darlings
[`niv`]: https://www.github.com/nmattia/niv
[`nix-direnv`]: https://github.com/nix-community/nix-direnv
[`lorri`]: https://www.github.com/target/lorri
[`direnv`]: https://www.github.com/direnv/direnv
[GC Root]: https://nixos.org/nixos/nix-pills/garbage-collector.html#idm140737315973184
