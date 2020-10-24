final: prev: {
  nix-direnv = prev.nix-direnv.override { nix = prev.nixFlakes; };

  # emacsMacport = final.unstable.emacsMacport;

  # # NOTE: Updating 'git' for the 2.28.0 changes which provide 'git-init'
  # # templates; this can be removed after updating to '20.09'.
  # # git = final.unstable.git;
  # # NOTE: As of 10 Oct. 2020, 'delta' isn't cached by the pinned 'unstable'
  # # package set, so it compiles and pulls in 'rustc'.
  # gitAndTools = (prev.gitAndTools or {}) // {
  #   delta = final.unstable.gitAndTools.delta;
  # };

  # lorri = final.unstable.lorri;
}
