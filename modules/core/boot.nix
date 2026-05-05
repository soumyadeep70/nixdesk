{
  pkgs,
  ...
}:
{
  boot = {
    consoleLogLevel = 0;

    initrd = {
      enable = true;
      systemd.enable = true;
    };

    loader = {
      timeout = 3;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        memtest86.enable = true;
      };
    };

    plymouth.enable = true;
  };

  environment.systemPackages = [ pkgs.efibootmgr ];
}
