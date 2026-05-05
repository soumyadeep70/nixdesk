{
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.nixdesk.core.storage;
in
{
  imports = [
    inputs.disko.nixosModules.default
    ./impermanence.nix
  ];

  options.nixdesk.core.storage = {
    # As of now only btrfs is supported
    systemDisk = lib.mkOption {
      type = lib.types.submodule {
        options = {
          blockDevice = lib.mkOption {
            type = lib.types.strMatching "^/dev/.+";
            description = "Raw block device (where nixos will be installed), don't specify any partition";
            example = "/dev/disk/by-id/nvme-XXXX";
          };
          mountpoint = lib.mkOption {
            type = lib.types.nonEmptyStr;
            default = "/btrfs";
            description = "Mountpoint for the raw unlocked (if encrypted) Btrfs filesystem";
            example = "/mnt/btrfs";
          };
          encryption = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkEnableOption "full disk encryption using LUKS";
                deviceName = lib.mkOption {
                  type = lib.types.nonEmptyStr;
                  default = "cryptroot";
                  description = "Name of LUKS mapper device";
                };
              };
            };
            default = { };
            description = "LUKS encryption config";
          };
          compression = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkEnableOption "compression for the whole btrfs filesystem";
                mode = lib.mkOption {
                  type = lib.types.strMatching "^(zstd(:[0-9]{1,2})?|lzo)$";
                  default = "zstd:1";
                  description = "Btrfs compression method";
                  example = "lzo";
                };
              };
            };
            default = { };
            description = "Btrfs compression config";
          };
          swap = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkEnableOption "swap";
                size = lib.mkOption {
                  type = lib.types.strMatching "^[1-9][0-9]*(M|G|T)$";
                  default = "4G";
                  description = "swapfile size";
                  example = "16G";
                };
              };
            };
            default = { };
            description = "Swap configuration";
          };
        };
      };
      default = { };
      description = "System disk config";
    };
    extraDisks = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              device = lib.mkOption {
                type = lib.types.strMatching "^/dev/.+";
                description = "The device path which has a mountable filesystem";
                example = "/dev/disk/by-id/nvme-XXXX";
              };
              mountpoint = lib.mkOption {
                type = lib.types.nonEmptyStr;
                default = name;
                description = "Mountpoint of the filesystem";
                example = "/data";
              };
              fsType = lib.mkOption {
                type = lib.types.nullOr (
                  lib.types.enum [
                    "btrfs"
                    "ext4"
                    "xfs"
                    "ntfs3"
                    "vfat"
                    "exfat"
                  ]
                );
                default = null;
                description = "The filesystem type of the disk (autodetect if unspecified)";
                example = "ntfs3";
              };
              extraOptions = lib.mkOption {
                type = lib.types.listOf lib.types.nonEmptyStr;
                default = [ ];
                description = ''
                  Options used to mount the file system.
                  This is called `options` in {manpage}`mount(8)` and `fs_mntops` in {manpage}`fstab(5)`
                  Some options that can be used for all mounts are documented in {manpage}`mount(8)` under `FILESYSTEM-INDEPENDENT MOUNT OPTIONS`.
                  Options that systemd understands are documented in {manpage}`systemd.mount(5)` under `FSTAB`.
                  Each filesystem supports additional options, see the docs for that filesystem.
                '';
                example = [ "data=journal" ];
              };
            };
          }
        )
      );
      default = { };
      description = "Extra disks/drives to automount";
    };
  };

  config =
    let
      espConfig = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
      };

      btrfsConfig =
        let
          compressionOpt = lib.optional cfg.systemDisk.compression.enable "compress=${cfg.systemDisk.compression.mode}";
        in
        {
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            inherit (cfg.systemDisk) mountpoint;

            subvolumes = {
              "root/current" = {
                mountpoint = "/";
                mountOptions = [ "noatime" ] ++ compressionOpt;
              };
              "nix" = {
                mountpoint = "/nix";
                mountOptions = [ "noatime" ] ++ compressionOpt;
              };
            }
            // lib.optionalAttrs cfg.systemDisk.impermanence.enable {
              "persist" = {
                mountpoint = "/persist";
                mountOptions = [ "noatime" ] ++ compressionOpt;
              };
            }
            // lib.optionalAttrs cfg.systemDisk.swap.enable {
              "swap" = {
                mountpoint = "/.swapvol";
                swap.swapfile.size = cfg.systemDisk.swap.size;
              };
            };
            # // lib.mapAttrs' (
            #   _: subvolCfg:
            #   lib.nameValuePair "${subvolCfg.name}" {
            #     inherit (subvolCfg) mountpoint;
            #     mountOptions = [ "noatime" ] ++ compressionOpt;
            #   }
            # ) cfg.systemDisk.extraSubvols;
          };
        };
    in
    {
      disko.devices = {
        disk."main" = {
          type = "disk";
          device = cfg.systemDisk.blockDevice;
          content = {
            type = "gpt";
            partitions =
              espConfig
              // (
                if cfg.systemDisk.encryption.enable then
                  {
                    luks = {
                      size = "100%";
                      content = {
                        type = "luks";
                        name = cfg.systemDisk.encryption.deviceName;
                        settings.allowDiscards = true;
                        inherit (btrfsConfig) content;
                      };
                    };
                  }
                else
                  {
                    btrfs = btrfsConfig;
                  }
              );
          };
        };
      };

      fileSystems =
        lib.mkIf cfg.systemDisk.impermanence.enable {
          "/persist".neededForBoot = true;
        }
        // lib.mapAttrs' (_: diskCfg: {
          name = diskCfg.mountpoint;
          value = {
            inherit (diskCfg) device;
            options = [
              "nosuid"
              "nodev"
              "relatime"
              "nofail"
            ]
            ++
              lib.optionals
                (builtins.elem diskCfg.fsType [
                  "ntfs3"
                  "exfat"
                  "vfat"
                ])
                [
                  "uid=1000"
                  "gid=100"
                ]
            ++ lib.optionals (diskCfg.fsType == "ntfs3") [
              "prealloc"
              "windows_names"
            ]
            ++ diskCfg.extraOptions;
          }
          // lib.optionalAttrs (diskCfg.fsType != null) {
            inherit (diskCfg) fsType;
          };
        }) cfg.extraDisks;

      services = {
        fstrim.enable = true;
        smartd = lib.mkIf (config.nixdesk.core.system.platform == "bare-metal") {
          enable = true;
          autodetect = true;
        };
      };
    };
}
