{
  pkgs,
  ...
}:
{
  virtualisation.incus = {
    enable = true;
    package = pkgs.incus;
    bucketSupport = false;
    ui.enable = true;
    preseed = {
      config = {
        "core.https_address" = "[::]:8443";
      };
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          project = "default";
          config = {
            "ipv4.address" = "auto";
            "ipv6.address" = "none";
          };
        }
      ];
      storage_pools = [
        {
          name = "default";
          driver = "btrfs";
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
        }
      ];
      profiles = [
        {
          name = "default";
          description = "Default Incus profile";
          config = {
            "security.nesting" = true;
          };
          devices = {
            eth0 = {
              name = "eth0";
              network = "incusbr0";
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              type = "disk";
            };
          };
        }
      ];
    };
  };
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
  nixdesk.core.storage.systemDisk.impermanence.system.dirs = [
    "/var/lib/incus"
  ];
}
