{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdesk.services.docker;
in
{
  options.nixdesk.services.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        live-restore = true;
        features.buildkit = true;
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
        persistent = true;
        randomizedDelaySec = "30min";
      };
    };
    users.groups."docker".members = lib.mapAttrsToList (_: v: v.name) config.nixdesk.core.users;
  };
}
