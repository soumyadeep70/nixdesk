{
  lib,
  ...
}:
{
  home-manager.sharedModules = lib.singleton {
    programs.zoxide.enable = true;
  };
}
