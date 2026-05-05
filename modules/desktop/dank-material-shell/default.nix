{
  inputs,
  inputs',
  lib,
  specs,
  repoRoot,
  ...
}:
{
  imports = [
    inputs.dank-material-shell.nixosModules.default
    ./login-manager.nix
    ./backends/niri.nix
    ./theming.nix
    ./utils.nix
  ];

  config = lib.mkIf (specs.desktop.variant == "dank-material-shell") {
    # dependencies
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    programs.dank-material-shell = {
      enable = true;
      systemd.enable = false;
      dgop.package = inputs'.dgop.packages.default;
    };

    home-manager.sharedModules = lib.singleton (
      { config, ... }:
      {
        imports = [
          inputs.dank-material-shell.homeModules.default
        ];

        programs.dank-material-shell.enable = true;

        #TODO: remove hardcoded path
        xdg.configFile."DankMaterialShell/settings.json".source = config.lib.file.mkOutOfStoreSymlink (
          repoRoot + "/modules/desktop/dank-material-shell/settings.json"
        );
        xdg.stateFile."DankMaterialShell/session.json".source = config.lib.file.mkOutOfStoreSymlink (
          repoRoot + "/modules/desktop/dank-material-shell/session.json"
        );
      }
    );
  };
}
