{
  lib,
  ...
}:
{
  home-manager.sharedModules = lib.singleton {
    programs.eza.enable = true;

    programs.zsh.shellAliases = {
      ll = "eza -lah --group-directories-first --icons";
      ls = "eza --icons";
    };
  };
}
