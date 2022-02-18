{ lib, vscode-extensions, vscode-utils, ... }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  eamodio.gitlens = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.7.0";
      sha256 = "po8JzwrADPSZY2SBlaX3N6VSURP/PZIGjFhS3hyV8io=";
    };
  };

  matklad.rust-analyzer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "rust-analyzer";
      publisher = "matklad";
      version = "0.3.935";
      sha256 = "/lOPQPRpE0+Zo/L94hGoJ5yeMMptrnJMxUgqeQiF3ts=";
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
      version = "1.5.1";
      sha256 = "+iIRswutBa+UM+37niemJbk8eo1IBHodhKBAmfGLe50=";
    };
  };
in

[
  eamodio.gitlens
  matklad.rust-analyzer
  sjurmillidahl.ormolu-vscode
  tamasfe.even-better-toml
  trond-snekvik.simple-rst
] ++
(with vscode-extensions; [
  bbenoist.nix
  gruntfuggly.todo-tree
  timonwong.shellcheck
  vadimcn.vscode-lldb
  vscodevim.vim
])
