let
  mkCache = url: key: { inherit url key; };

  default = mkCache
    "https://cache.nixos.org"
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";

  iohk = mkCache
    "https://iohk.cachix.org"
    "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo=";

  caches = [
    default
    iohk
  ];
in

{
  substituters = builtins.map (cache: cache.url) caches;
  keys = builtins.map (cache: cache.key) caches;
}
