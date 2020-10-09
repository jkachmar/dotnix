_final: prev: {
  emacsMacport = prev.unstable.emacsMacport;

  gitAndTools = (prev.gitAndTools or {}) // {
    delta = prev.unstable.gitAndTools.delta;
  };

  lorri = prev.unstable.lorri;
}
