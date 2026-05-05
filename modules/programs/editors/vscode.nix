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
            jnoortheen.nix-ide
            tamasfe.even-better-toml
            dbaeumer.vscode-eslint
            bradlc.vscode-tailwindcss
            esbenp.prettier-vscode
          ];
        };
      };
      xdg.configFile."Code/User/settings.json" = config.lib.file.mkOutOfStoreSymlink (
        repoRoot + "/modules/programs/editors/vscode-settings.json"
      );
    }
  );

}
