# Nixdesk 🖥️

A NixOS configuration framework built around reproducibility and a clean system state. Uses an ephemeral root — meaning your root filesystem resets on reboot, keeping only what you explicitly declare. Swap desktop environments, window managers, and packages without accumulating cruft.

---

## Getting Started 🚀

### 1. Fork the repository
Clone and fork this repo as your own base.

### 2. Remove the existing host configs
Delete the `phoenix` directories. They are hardware-specific and won't work on your machine.

### 3. Create your host
Inside the `hosts` folder, create a new directory named after your desired hostname.

### 4. Configure your host
- Add a `.arch` file containing either `x86_64-linux` or `aarch64-linux` depending on your architecture.
- Add a `default.nix` and configure your system. You can reference the existing configs as a starting point.

### 5. Boot into NixOS Live ISO 💿
You'll need this to run the installation steps.

### 6. Generate hardware configuration
```bash
nixos-generate-config --no-filesystems --show-hardware-config
```
Save the output as `hardware-configuration.nix` inside your host directory and import it in `default.nix`.

### 7. Install ⚙️
```bash
sudo nix --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko/latest' -- --flake .#<hostname> --mode destroy,format,mount
sudo nixos-install --flake .#<hostname>
```
Replace `<hostname>` with your actual hostname — not literally `<hostname>`.

---

## Secrets Management 🔐

Secrets are handled via `sops-nix`. SSH keys, Tailscale auth tokens, Rclone credentials — everything is encrypted at rest.

**Setup:**
1. Generate an age keypair: `age-keygen`
2. Place the private key at `var/lib/sops-nix/age-key.txt`
3. Add the public key to `.sops.yaml`
4. Recreate `shared.yaml` and `<hostname>.yaml` with your actual secrets

> ⚠️ **Important:** Do not commit plaintext secrets. If you lose your SOPS private key, the encrypted secrets are unrecoverable.