{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixdesk.secrets;

  sharedSecretsFile = ./shared.yaml;
  machineSecretsFile = ./${config.networking.hostName}.yaml;

  # -------- YAML → JSON → Nix attrs --------
  yamlToAttrs =
    file:
    if builtins.pathExists file then
      builtins.fromJSON (
        builtins.readFile (
          pkgs.runCommand "yaml-to-json" { } ''
            ${pkgs.yq-go}/bin/yq -o=json < ${file} > $out
          ''
        )
      )
    else
      { };

  # -------- extract key paths --------
  flattenKeys =
    attrs:
    let
      recurse =
        path: value:
        if lib.isAttrs value then
          lib.concatLists (lib.mapAttrsToList (k: v: recurse (path ++ [ k ]) v) value)
        else
          [ (lib.concatStringsSep "/" path) ];
    in
    recurse [ ] attrs;

  sharedSecretsKeys = flattenKeys (removeAttrs (yamlToAttrs sharedSecretsFile) [ "sops" ]);
  machineSecretsKeys = flattenKeys (removeAttrs (yamlToAttrs machineSecretsFile) [ "sops" ]);
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.nixdesk.secrets = {
    enable = lib.mkEnableOption "secrets management via sops";
    authorizedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of users to give access to the secrets";
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      let
        overlappingSecrets = lib.intersectLists sharedSecretsKeys machineSecretsKeys;
      in
      lib.optional (overlappingSecrets != [ ]) ''
        Overridden secrets (machine overrides shared):
        ${lib.concatStringsSep "\n" overlappingSecrets}
      '';

    sops.age.keyFile = "/persist/system/var/lib/sops-nix/age-key.txt";
    # hard dependency
    nixdesk.core.storage.systemDisk.impermanence.system.dirs = [
      "/var/lib/sops-nix"
    ];

    users.groups."secrets".members = cfg.authorizedUsers;
    sops.secrets =
      (lib.genAttrs sharedSecretsKeys (key: {
        sopsFile = sharedSecretsFile;
        inherit key;
        group = "secrets";
        mode = "0440";
      }))
      // (lib.genAttrs machineSecretsKeys (key: {
        sopsFile = machineSecretsFile;
        inherit key;
        group = "secrets";
        mode = "0440";
      }));

    _module.args.getSecret = key: config.sops.secrets.${key}.path;
  };
}
