{
  lib,
  ...
}:
{
  home-manager.sharedModules = lib.singleton {
    programs.bat.enable = true;

    programs.zsh.shellAliases = {
      cat = "bat";
    };
  };
}
