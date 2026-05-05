## nixdesk\.core\.nix\.disableChannels

Whether to disable channels (recommended)



*Type:*
boolean



*Default:*

```nix
true
```

*Declared by:*
 - [modules/core/nix\.nix](modules/core/nix.nix)



## nixdesk\.core\.storage\.extraDisks



Extra disks/drives to automount



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.extraDisks\.\<name>\.device



The device path which has a mountable filesystem



*Type:*
string matching the pattern ^/dev/\.+



*Example:*

```nix
"/dev/disk/by-id/nvme-XXXX"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.extraDisks\.\<name>\.extraOptions



Options used to mount the file system\.
This is called ` options ` in [` mount(8) `](https://man.archlinux.org/man/mount.8) and ` fs_mntops ` in [` fstab(5) `](https://man.archlinux.org/man/fstab.5)
Some options that can be used for all mounts are documented in [` mount(8) `](https://man.archlinux.org/man/mount.8) under ` FILESYSTEM-INDEPENDENT MOUNT OPTIONS `\.
Options that systemd understands are documented in [` systemd.mount(5) `](https://www.freedesktop.org/software/systemd/man/systemd.mount.html) under ` FSTAB `\.
Each filesystem supports additional options, see the docs for that filesystem\.



*Type:*
list of non-empty string



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "data=journal"
]
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.extraDisks\.\<name>\.fsType



The filesystem type of the disk (autodetect if unspecified)



*Type:*
null or one of “btrfs”, “ext4”, “xfs”, “ntfs3”, “vfat”, “exfat”



*Default:*

```nix
null
```



*Example:*

```nix
"ntfs3"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.extraDisks\.\<name>\.mountpoint



Mountpoint of the filesystem



*Type:*
non-empty string



*Default:*

```nix
"‹name›"
```



*Example:*

```nix
"/data"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk



System disk config



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.blockDevice



Raw block device (where nixos will be installed), don’t specify any partition



*Type:*
string matching the pattern ^/dev/\.+



*Example:*

```nix
"/dev/disk/by-id/nvme-XXXX"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.compression



Btrfs compression config



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.compression\.enable



Whether to enable compression for the whole btrfs filesystem\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.compression\.mode



Btrfs compression method



*Type:*
string matching the pattern ^(zstd(:\[0-9]{1,2})?|lzo)$



*Default:*

```nix
"zstd:1"
```



*Example:*

```nix
"lzo"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.encryption



LUKS encryption config



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.encryption\.enable



Whether to enable full disk encryption using LUKS\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.encryption\.deviceName



Name of LUKS mapper device



*Type:*
non-empty string



*Default:*

```nix
"cryptroot"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.enable



Whether to enable impermanence\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.system



System persistence config



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.system\.dirs



System directories to persist



*Type:*
list of (string or (attribute set))



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "/var/lib/bluetooth"
  "/var/lib/nixos"
  { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
]

```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.system\.files



System files to persist



*Type:*
list of (string or (attribute set))



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "/etc/machine-id"
  { file = "/var/keys/secret_file"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
]

```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.user



Persistence config for all users



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.user\.dirs



Per-user directories to persist\. Supports XDG variable substitution:

 - ` @configHome ` → XDG_CONFIG_HOME (default: ` ~/.config `)
 - ` @dataHome ` → XDG_DATA_HOME (default: ` ~/.local/share `)
 - ` @cacheHome ` → XDG_CACHE_HOME (default: ` ~/.cache `)
 - ` @stateHome ` → XDG_STATE_HOME (default: ` ~/.local/state `)

Example: ` "@configHome/nvim" ` expands to ` ~/.config/nvim `



*Type:*
list of (string or (attribute set))



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  "Pictures"
  "Documents"
  "@dataHome/direnv"
  { directory = ".ssh"; mode = "0700"; }
  { directory = "@dataHome/keyrings"; mode = "0700"; }
]

```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.impermanence\.user\.files



Per-user files to persist\. Supports XDG variable substitution

 - ` @configHome ` → XDG_CONFIG_HOME (default: ` ~/.config `)
 - ` @dataHome ` → XDG_DATA_HOME (default: ` ~/.local/share `)
 - ` @cacheHome ` → XDG_CACHE_HOME (default: ` ~/.cache `)
 - ` @stateHome ` → XDG_STATE_HOME (default: ` ~/.local/state `)

Example: ` "@configHome/nvim" ` expands to ` ~/.config/nvim `



*Type:*
list of (string or (attribute set))



*Default:*

```nix
[ ]
```



*Example:*

```nix
[
  ".screenrc"
]

```

*Declared by:*
 - [modules/core/storage/impermanence\.nix](modules/core/storage/impermanence.nix)



## nixdesk\.core\.storage\.systemDisk\.mountpoint



Mountpoint for the raw unlocked (if encrypted) Btrfs filesystem



*Type:*
non-empty string



*Default:*

```nix
"/btrfs"
```



*Example:*

```nix
"/mnt/btrfs"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.swap



Swap configuration



*Type:*
submodule



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.swap\.enable



Whether to enable swap\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.storage\.systemDisk\.swap\.size



swapfile size



*Type:*
string matching the pattern ^\[1-9]\[0-9]\*(M|G|T)$



*Default:*

```nix
"4G"
```



*Example:*

```nix
"16G"
```

*Declared by:*
 - [modules/core/storage/default\.nix](modules/core/storage/default.nix)



## nixdesk\.core\.system\.homeStateVersion



Home-manager stateversion\. See ` home.stateVersion ` nixos option



*Type:*
string matching the pattern ^\[0-9]{2}\.\[0-9]{2}$



*Example:*

```nix
"25.11"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.system\.kernel



The linux kernel to use



*Type:*
one of “latest”, “zen”, “xanmod”



*Default:*

```nix
"latest"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.system\.locale



Define the locale



*Type:*
string



*Default:*

```nix
"en_US.UTF-8"
```



*Example:*

```nix
"bn_IN.UTF-8"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.system\.machineId



The unique machine ID of the system, a single hexadecimal, 32-character, lowercase ID



*Type:*
string



*Example:*

```nix
"9471422d94d34bb8807903179fb35f11"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.system\.platform



Whether the system is virtualized or not



*Type:*
one of “bare-metal”, “vm”



*Default:*

```nix
"bare-metal"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.system\.stateVersion



Nixos system stateversion\. See ` system.stateVersion ` nixos option



*Type:*
string matching the pattern ^\[0-9]{2}\.\[0-9]{2}$



*Example:*

```nix
"25.11"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.system\.timeZone



Set the timezone



*Type:*
string



*Default:*

```nix
"UTC"
```



*Example:*

```nix
"Asia/Kolkata"
```

*Declared by:*
 - [modules/core/system\.nix](modules/core/system.nix)



## nixdesk\.core\.users



Users config



*Type:*
attribute set of (submodule)



*Default:*

```nix
{ }
```

*Declared by:*
 - [modules/core/users\.nix](modules/core/users.nix)



## nixdesk\.core\.users\.\<name>\.description



Description of the user, typically the full name



*Type:*
string



*Example:*

```nix
"Primary User"
```

*Declared by:*
 - [modules/core/users\.nix](modules/core/users.nix)



## nixdesk\.core\.users\.\<name>\.hashedPassword



The hashed password generated using ` mkpasswd -m sha-512 `



*Type:*
null or string



*Default:*

```nix
null
```



*Example:*

```nix
"$6$O7iaJnN4vPi39APR$7sO..........."
```

*Declared by:*
 - [modules/core/users\.nix](modules/core/users.nix)



## nixdesk\.core\.users\.\<name>\.isAdmin



Whether the user is system administrator or not



*Type:*
boolean



*Example:*

```nix
true
```

*Declared by:*
 - [modules/core/users\.nix](modules/core/users.nix)



## nixdesk\.core\.users\.\<name>\.name



The primary user of the system



*Type:*
string



*Default:*

```nix
"‹name›"
```



*Example:*

```nix
"admin"
```

*Declared by:*
 - [modules/core/users\.nix](modules/core/users.nix)



## nixdesk\.programs\.git\.userEmail



The git user email



*Type:*
string



*Example:*

```nix
"bob@example.com"
```

*Declared by:*
 - [modules/programs/cli/git\.nix](modules/programs/cli/git.nix)



## nixdesk\.programs\.git\.userName



The git username



*Type:*
string



*Example:*

```nix
"bob"
```

*Declared by:*
 - [modules/programs/cli/git\.nix](modules/programs/cli/git.nix)



## nixdesk\.programs\.rclone\.GoogleDrive\.enable



Whether to enable Whether to automount google drive\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/programs/rclone\.nix](modules/programs/rclone.nix)



## nixdesk\.programs\.rclone\.GoogleDrive\.clientIdFile



The client_id secret



*Type:*
string



*Example:*

```nix
"/run/secrets/gdrive_client_id"
```

*Declared by:*
 - [modules/programs/rclone\.nix](modules/programs/rclone.nix)



## nixdesk\.programs\.rclone\.GoogleDrive\.clientSecretFile



The client_secret secret



*Type:*
string



*Example:*

```nix
"/run/secrets/gdrive_client_secret"
```

*Declared by:*
 - [modules/programs/rclone\.nix](modules/programs/rclone.nix)



## nixdesk\.programs\.rclone\.GoogleDrive\.tokenFile



The token secret



*Type:*
string



*Example:*

```nix
"/run/secrets/gdrive_token"
```

*Declared by:*
 - [modules/programs/rclone\.nix](modules/programs/rclone.nix)



## nixdesk\.programs\.ssh\.githubPrivateKeyFile



File containing the github private key



*Type:*
string



*Example:*

```nix
"/run/secrets/github_key"
```

*Declared by:*
 - [modules/programs/cli/ssh\.nix](modules/programs/cli/ssh.nix)



## nixdesk\.programs\.ssh\.gitlabPrivateKeyFile



File containing the gitlab private key



*Type:*
string



*Example:*

```nix
"/run/secrets/gitlab_key"
```

*Declared by:*
 - [modules/programs/cli/ssh\.nix](modules/programs/cli/ssh.nix)



## nixdesk\.services\.docker\.enable



Whether to enable docker\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/services/docker\.nix](modules/services/docker.nix)



## nixdesk\.services\.tailscale\.enable



Whether to enable tailscale\.



*Type:*
boolean



*Default:*

```nix
false
```



*Example:*

```nix
true
```

*Declared by:*
 - [modules/services/tailscale\.nix](modules/services/tailscale.nix)



## nixdesk\.services\.tailscale\.authKeyFile



The key for authenticating with tailscale



*Type:*
string



*Example:*

```nix
"/run/secrets/tailscale_auth_key"
```

*Declared by:*
 - [modules/services/tailscale\.nix](modules/services/tailscale.nix)


