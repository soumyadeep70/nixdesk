{
  lib,
  pkgs,
  repoRoot,
  ...
}:
{
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  home-manager.sharedModules = lib.singleton (
    { config, ... }:
    {
      programs.vscode = {
        enable = true;
        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            tobiasalthoff.atom-material-theme
            pkief.material-icon-theme
            ms-vscode-remote.remote-containers
          ];
        };
      };
      xdg.configFile."Code/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink (
        repoRoot + "/modules/programs/editors/vscode-settings.json"
      );
    }
  );

  nixdesk.core.storage.systemDisk.impermanence.user.dirs = [
    "@configHome/Code"
  ];
}
