{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdesk.core.users;
in
{
  options.nixdesk.core.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = "The primary user of the system";
              example = "admin";
            };
            description = lib.mkOption {
              type = lib.types.str;
              description = "Description of the user, typically the full name";
              example = "Primary User";
            };
            hashedPassword = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "The hashed password generated using `mkpasswd -m sha-512`";
              example = "$6$O7iaJnN4vPi39APR$7sO...........";
            };
            isAdmin = lib.mkOption {
              type = lib.types.bool;
              description = "Whether the user is system administrator or not";
              example = true;
            };
          };
        }
      )
    );
    default = { };
    description = "Users config";
  };

  config = {
    users.mutableUsers = false;
    users.users = lib.mapAttrs (_: userCfg: {
      isNormalUser = true;
      inherit (userCfg) name description hashedPassword;
      useDefaultShell = true;
      extraGroups = lib.optional userCfg.isAdmin "wheel";
    }) cfg;

    security.sudo.extraConfig = ''
      Defaults lecture=never
      Defaults timestamp_timeout=30
    '';

    home-manager.users = lib.mapAttrs' (_: userCfg: {
      inherit (userCfg) name;
      value = {
        home = {
          username = userCfg.name;
          homeDirectory = "/home/${userCfg.name}";
        };
      };
    }) cfg;

    nixdesk.core.storage.systemDisk.impermanence.user.dirs = [
      "@dataHome/Trash"
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
    ];
  };
}
