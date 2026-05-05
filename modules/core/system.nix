{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixdesk.core.system;
  kernels = {
    latest = pkgs.linuxPackages_latest;
    zen = pkgs.linuxPackages_zen;
    xanmod = pkgs.linuxPackages_xanmod_latest;
  };
in
{
  options.nixdesk.core.system = {
    platform = lib.mkOption {
      type = lib.types.enum [
        "bare-metal"
        "vm"
      ];
      default = "bare-metal";
      description = "Whether the system is virtualized or not";
    };
    kernel = lib.mkOption {
      type = lib.types.enum [
        "latest"
        "zen"
        "xanmod"
      ];
      default = "latest";
      description = "The linux kernel to use";
    };
    machineId = lib.mkOption {
      type = lib.types.addCheck lib.types.str (
        v:
        let
          isLowerHex = (lib.match "^[0-9a-f]+$" v) != null;
          isLength = lib.stringLength v == 32;
        in
        isLowerHex && isLength
      );
      description = "The unique machine ID of the system, a single hexadecimal, 32-character, lowercase ID";
      example = "9471422d94d34bb8807903179fb35f11";
    };
    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "Define the locale";
      example = "bn_IN.UTF-8";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      description = "Set the timezone";
      example = "Asia/Kolkata";
    };
    stateVersion = lib.mkOption {
      type = lib.types.strMatching "^[0-9]{2}\.[0-9]{2}$";
      description = "Nixos system stateversion. See `system.stateVersion` nixos option";
      example = "25.11";
    };
    homeStateVersion = lib.mkOption {
      type = lib.types.strMatching "^[0-9]{2}\.[0-9]{2}$";
      description = "Home-manager stateversion. See `home.stateVersion` nixos option";
      example = "25.11";
    };
  };

  config = {
    boot = {
      kernelPackages = kernels.${cfg.kernel};
      kernelParams = [
        "quiet"
        "splash"
        "udev.log_level=3"
        "boot.shell_on_fail"
        "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"
      ];
    };

    services.qemuGuest.enable = lib.mkIf (cfg.platform == "vm") true;
    services.spice-vdagentd.enable = lib.mkIf (cfg.platform == "vm") true;

    environment.etc.machine-id.text = cfg.machineId;
    networking.hostId = lib.substring 0 8 cfg.machineId;

    time.timeZone = cfg.timeZone;

    i18n.defaultLocale = cfg.locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.locale;
      LC_IDENTIFICATION = cfg.locale;
      LC_MEASUREMENT = cfg.locale;
      LC_MONETARY = cfg.locale;
      LC_NAME = cfg.locale;
      LC_NUMERIC = cfg.locale;
      LC_PAPER = cfg.locale;
      LC_TELEPHONE = cfg.locale;
      LC_TIME = cfg.locale;
      LC_COLLATE = cfg.locale;
    };

    system = { inherit (cfg) stateVersion; };
    home-manager.sharedModules = lib.singleton {
      home.stateVersion = cfg.homeStateVersion;
    };

    nixdesk.core.storage.systemDisk.impermanence.system = {
      dirs = [
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timers"
        "/var/lib/systemd/timesync"
      ];
      files = [
        "/var/lib/systemd/random-seed"
      ];
    };
  };
}
