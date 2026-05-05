## Bare Metal Installation
## CPU -- i3 7020U

{
  inputs,
  self,
  getSecret,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    self.nixosModules.default
    ./hardware-configuration.nix
  ];

  nixdesk.secrets = {
    enable = true;
    authorizedUsers = [ "cypher" ];
  };

  nixdesk.core = {
    system = {
      platform = "bare-metal";
      kernel = "latest";
      machineId = "9f3c7a2d8e1b4c6fa0d5e97b31c2a864";
      locale = "en_US.UTF-8";
      timeZone = "Asia/Kolkata";
      stateVersion = "26.05";
      homeStateVersion = "26.05";
    };
    users = {
      cypher = {
        description = "Cypher";
        hashedPassword = "$6$O7iaJnN4vPi39APR$7sOcUv7/zqA/kN916tuITWRT7IQRogIzm6hbbyZR3zy7aXGsX9CUgG3R1Z3WaT4LRJ80RpH2PS0TtR5wlFGLZ/";
        isAdmin = true;
      };
    };

    storage = {
      systemDisk = {
        blockDevice = "nvme-WDC_WDS250G2B0C-00PXH0_20240B800186";
        encryption.enable = true;
        compression.enable = true;
        swap = {
          enable = true;
          size = "16G";
        };
        impermanence.enable = true;
      };
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "intel-media-sdk-23.2.2"
  ];
  hardware.intelgpu = {
    driver = "i915";
    vaapiDriver = "intel-media-driver";
    computeRuntime = "legacy";
    mediaRuntime = "intel-media-sdk";
  };

  nixdesk.programs = {
    git = {
      userName = "soumyadeep70";
      userEmail = "soumyadeepdash70@gmail.com";
    };
    ssh = {
      githubPrivateKeyFile = getSecret "github/ssh_private_key";
      gitlabPrivateKeyFile = getSecret "gitlab/ssh_private_key";
    };
    rclone = {
      GoogleDrive = {
        enable = true;
        clientIdFile = getSecret "rclone/gdrive/client_id";
        clientSecretFile = getSecret "rclone/gdrive/client_secret";
        tokenFile = getSecret "rclone/gdrive/token";
      };
    };
  };

  nixdesk.services = {
    docker.enable = true;
    tailscale = {
      enable = true;
      authKeyFile = getSecret "tailscale/auth_key";
    };
  };
}
