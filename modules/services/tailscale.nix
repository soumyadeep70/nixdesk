{
  config,
  lib,
  ...
}:
let
  cfg = config.nixdesk.services.tailscale;
in
{
  options.nixdesk.services.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    authKeyFile = lib.mkOption {
      type = lib.types.str;
      description = "The key for authenticating with tailscale";
      example = "/run/secrets/tailscale_auth_key";
    };
  };

  config = {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      inherit (cfg) authKeyFile;
    };
  };
}
