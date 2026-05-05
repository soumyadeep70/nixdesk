{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdesk.programs.ssh;
in
{
  options.nixdesk.programs.ssh = {
    githubPrivateKeyFile = lib.mkOption {
      type = lib.types.str;
      description = "File containing the github private key";
      example = "/run/secrets/github_key";
    };
    gitlabPrivateKeyFile = lib.mkOption {
      type = lib.types.str;
      description = "File containing the gitlab private key";
      example = "/run/secrets/gitlab_key";
    };
  };

  config = {
    home-manager.sharedModules = lib.singleton {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            forwardAgent = false;
            addKeysToAgent = "no";
            compression = false;
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
          "github.com" = {
            user = "git";
            hostname = "github.com";
            identityFile = cfg.githubPrivateKeyFile;
            identitiesOnly = true;
          };
          "gitlab.com" = {
            user = "git";
            hostname = "gitlab.com";
            identityFile = cfg.gitlabPrivateKeyFile;
            identitiesOnly = true;
          };
        };
      };
    };
  };
}
