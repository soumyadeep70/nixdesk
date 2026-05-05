{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.nixdesk.core.nix;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  options.nixdesk.core.nix = {
    disableChannels = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to disable channels (recommended)";
    };
  };

  config = lib.mkMerge [
    {
      programs.nix-index-database.comma.enable = true;

      nixpkgs.config.allowUnfree = true;
      environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

      nix.settings = {
        trusted-users = [ "@wheel" ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        connect-timeout = 5;
        log-lines = 25;
        min-free = 1073741824;
        max-free = 5368709120;
        fallback = true;
        auto-optimise-store = true;
        warn-dirty = false;

        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.flox.dev"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs="
        ];
      };
    }
    (lib.mkIf cfg.disableChannels (
      let
        flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
      in
      {
        nix = {
          channel.enable = false;
          # all lookups must come from your flake inputs
          registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
          settings.flake-registry = "";
          nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
        };
      }
    ))
  ];
}
