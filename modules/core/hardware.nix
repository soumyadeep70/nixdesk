{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # Firmwares
    {
      hardware.enableAllFirmware = true;
      services.fwupd.enable = true;
      nixdesk.core.storage.systemDisk.impermanence.system = {
        dirs = [
          "/var/lib/fwupd/gnupg"
          "/var/lib/fwupd/metadata"
          "/var/lib/fwupd/pki"
        ];
        files = [
          "/var/lib/fwupd/pending.db"
        ];
      };
    }
    # Graphics Drivers (GPU specific drivers should me manually configured)
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    }
    # Bluetooth
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
      nixdesk.core.storage.systemDisk.impermanence.system.dirs = [
        "/var/lib/bluetooth"
      ];
    }
    # Multimedia (Audio, Screen Sharing)
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };
      services.pulseaudio.enable = lib.mkForce false;
      security.rtkit.enable = lib.mkDefault true;
      nixdesk.core.storage.systemDisk.impermanence.user.dirs = [
        "@stateHome/wireplumber"
      ];
    }
    # Printing
    {
      services.printing.enable = true;
    }
    # DDC/CI protocol (monitor brightness control)
    {
      hardware.i2c.enable = true;
      environment.systemPackages = [ pkgs.ddcutil ];
      users.groups."i2c".members = lib.mapAttrsToList (_: v: v.name) config.nixdesk.core.users;
    }
    # TPM 2.0 support
    {
      security.tpm2.enable = true;
      nixdesk.core.storage.systemDisk.impermanence.system.dirs = [
        "/var/lib/tpm2-tss"
      ];
    }
  ];
}
