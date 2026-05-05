{
  lib,
  ...
}:
{
  home-manager.sharedModules = lib.singleton {
    programs.fzf.enable = true;
  };
}
