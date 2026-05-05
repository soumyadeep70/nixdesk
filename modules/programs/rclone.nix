{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdesk.programs.rclone;
in
{
  options.nixdesk.programs.rclone = {
    GoogleDrive = {
      enable = lib.mkEnableOption "Whether to automount google drive";
      clientIdFile = lib.mkOption {
        type = lib.types.str;
        description = "The client_id secret";
        example = "/run/secrets/gdrive_client_id";
      };
      clientSecretFile = lib.mkOption {
        type = lib.types.str;
        description = "The client_secret secret";
        example = "/run/secrets/gdrive_client_secret";
      };
      tokenFile = lib.mkOption {
        type = lib.types.str;
        description = "The token secret";
        example = "/run/secrets/gdrive_token";
      };
    };
  };

  config = {
    home-manager.sharedModules = lib.singleton (
      { config, ... }:
      {
        programs.rclone = {
          enable = true;

          remotes."gdrive" = lib.mkIf cfg.GoogleDrive.enable {
            config = {
              type = "drive";
              scope = "drive";
            };
            secrets = {
              client_id = cfg.GoogleDrive.clientIdFile;
              client_secret = cfg.GoogleDrive.clientSecretFile;
              token = cfg.GoogleDrive.tokenFile;
            };
            mounts."" = {
              enable = true;
              mountPoint = "${config.home.homeDirectory}/GoogleDrive";
              logLevel = "NOTICE";
              options = {
                vfs-cache-mode = "full";
                vfs-cache-max-size = "10G";
                vfs-cache-max-age = "24h";
                poll-interval = "30s";
                dir-cache-time = "5m";
                buffer-size = "32M";
                transfers = 8;
                read-only = false;
                allow-other = false;
              };
            };
          };
        };
      }
    );
  };
}
