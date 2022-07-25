{ lib, vscode-extensions, vscode-utils, ... }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  eamodio.gitlens = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "gitlens";
      publisher = "eamodio";
      version = "12.0.5";
      sha256 = "HOr+78UQHIVQDkUNQaWyyNzDQFc+HwhGRR0ha9Pmyn0=";
    };
  };

  rust-lang.rust-analyzer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "rust-analyzer";
      publisher = "rust-lang";
      version = "0.4.1086";
      sha256 = "1foFDbbTKoekAu88Ka91sucBawoRxT7alZXYCl8/mVk=";
    };
  };

  sjurmillidahl.ormolu-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "ormolu-vscode";
      publisher = "sjurmillidahl";
      version = "0.0.7";
      sha256 = "8k+j1naITxX9sa3IKIdePlhYQG4tFloZSfl6Hm0l8zk=";
    };
  };

  tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "even-better-toml";
      publisher = "tamasfe";
      version = "0.14.2";
      sha256 = "lE2t+KUfClD/xjpvexTJlEr7Kufo+22DUM9Ju4Tisp0=";
    };
  };

  trond-snekvik.simple-rst = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "simple-rst";
      publisher = "trond-snekvik";
      version = "1.5.2";
      sha256 = "pV7/S8kkDIbhD2K5P2TA8E0pM4F8gsFIlc+4FIheBbc=";
    };
  };
in

[
  eamodio.gitlens
  rust-lang.rust-analyzer
  sjurmillidahl.ormolu-vscode
  tamasfe.even-better-toml
  trond-snekvik.simple-rst
] ++
(with vscode-extensions; [
  bbenoist.nix
  gruntfuggly.todo-tree
  timonwong.shellcheck
  # NOTE: Fix has been merged but not propagated to 'unstable' yet.
  #
  # cf. https://github.com/NixOS/nixpkgs/issues/176697
  # vadimcn.vscode-lldb
  vscodevim.vim
])
