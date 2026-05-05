{
  config,
  lib,
  ...
}:
{
  networking.networkmanager.enable = true;
  users.groups."networkmanager".members = lib.mapAttrsToList (_: v: v.name) config.nixdesk.core.users;

  networking.nftables.enable = true;
  networking.firewall.enable = true;

  nixdesk.core.storage.systemDisk.impermanence.system.dirs = [
    "/etc/NetworkManager/system-connections"
  ];
}
