{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.fastfetch ];

  home-manager.sharedModules = lib.singleton {
    programs.fastfetch = {
      enable = true;
      settings.modules = [
        "title"
        "separator"
        "os"
        "host"
        "bios"
        "kernel"
        "uptime"
        "shell"
        "display"
        {
          "type" = "cpu";
          "showPeCoreCount" = true;
          "temp" = true;
        }
        {
          "type" = "gpu";
          "driverSpecific" = true;
          "temp" = true;
        }
        "memory"
        {
          "type" = "swap";
          "separate" = true;
        }
        "disk"
        {
          "type" = "battery";
          "temp" = true;
        }
        "wifi"
        "locale"
        "break"
        "colors"
      ];
    };
  };
}
