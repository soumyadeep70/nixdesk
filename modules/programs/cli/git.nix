{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixdesk.programs.git;
in
{
  options.nixdesk.programs.git = {
    userName = lib.mkOption {
      type = lib.types.str;
      description = "The git username";
      example = "bob";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "The git user email";
      example = "bob@example.com";
    };
  };

  config = {
    home-manager.sharedModules = lib.singleton {
      programs.git = {
        enable = true;
        package = pkgs.gitFull;
        settings = {
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };
          push.default = "simple";
          init.defaultBranch = "main";
          log.decorate = "full";
          log.date = "iso";
          merge.conflictStyle = "diff3";
        };
        lfs.enable = true;
      };
      programs.gitui.enable = true;

      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = false;
        settings.git_protocol = "ssh";
      };
      programs.gh-dash.enable = true;
    };
  };
}
