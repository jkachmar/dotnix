final: prev: {
  emacsMacport = final.unstable.emacsMacport;

  formats = final.unstable.formats;

  gitAndTools = (prev.gitAndTools or {}) // {
    delta = final.unstable.gitAndTools.delta;
  };

  lorri = final.unstable.lorri;
}
