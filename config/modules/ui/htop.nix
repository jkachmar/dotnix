#####################################
# OS-agnostic `htop` configuration. #
#####################################
{ ... }:
{
  primary-user.home-manager.programs.htop = {
    enable = true;
    hideUserlandThreads = true;
    treeView = true;
    showProgramPath = false;
    highlightBaseName = true;
    # XXX: This doesn't seem to do anything?
    # vimMode = true;
  };
}
