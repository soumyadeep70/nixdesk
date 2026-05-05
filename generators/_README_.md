# 🚀 Nixdesk: Functionality First (Because configuring your OS shouldn't be a full-time job)

Welcome to Nixdesk. If you're looking for a "pretty" rice from r/unixporn that breaks the moment you update a package, you're in the wrong place. Nixdesk is for the brave souls who want a reproducible system that *actually* works. 🛠️

We use an ephemeral root to keep things spicy yet clean. Experiment with DEs, WMs, and weird apps without turning your system into a digital landfill. 🗑️✨

## 🛠️ The Quest: Crafting Your New Host

Follow these steps carefully, or prepare to stare at a TTY in despair. 😱

1. **Fork the Repo**: Claim your territory. 🚩
2. **Purge the Old**: Delete the `__EXISTING_HOSTS__` folders. They are customized for my specific hardware and neurotic needs. They will not love you. 🚫
3. **Manifest Your Host**: Create a directory in the `hosts` folder. Name it whatever you want your hostname to be. Be bold. Be unique. 🌌
4. **The Blueprint**:
   - Create a `.arch` file in your host folder.
   - Write `x86_64-linux` or `aarch64-linux` (depending on whether your CPU is a standard brick or a fancy ARM slab). 💻
   - Create a `default.nix` and configure your heart's desire. Feel free to steal my configs — I'm not using them anyway. 🏴‍☠️
   - Commit and push, only if you didn't put the secrets as plaintext. You're almost there... but not quite. ⏳
5. **The Rite of Passage**: Boot into the NixOS Live ISO. 💿
6. **Hardware Ritual**: Run this to tell NixOS what your hardware actually is:
   ```bash
   nixos-generate-config --no-filesystems --show-hardware-config
   ```
   Grab that output and save it as `hardware-configuration.nix` in your host directory. **CRITICAL**: Import this file in your `default.nix` or your system will have the memory of a goldfish. 🐟
7. **The Grand Finale**:
   ```bash
   sudo nix --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko/latest' -- --flake .#{{hostname}} --mode destroy,format,mount --debug
   sudo nixos-install --flake .#{{hostname}}
   ```
   *(Replace `{{hostname}}` with your actual hostname, unless you want to install a system called "curly-braces-hostname".)* 🤡

## 🔑 Secrets, Lies, and Security

We use `sops-nix` because keeping secrets in plaintext is for people who enjoy identity theft. 🕵️‍♂️

SSH keys, Tailscale auth, Rclone tokens—everything is encrypted. 🔐

**⚠️ WARNING**: If you lose your SOPS private key, you haven't just lost your secrets; you've effectively factory-reset your digital existence. There is no "Forgot Password" button here. May the odds be ever in your favor. 🎲

**Getting Started with Secrets**:

1. Generate an age key-pair: `age-keygen`. 🔑
1. Shove the private key into `var/lib/sops-nix/age-key.txt`. 📂
1. Put the public key in `.sops.yaml`. 📝
1. Recreate `shared.yaml` and `{{hostname}}.yaml` with your actual secrets. 🤫

______________________________________________________________________

*Go forth and configure. May your builds be fast and your errors be few.* 🚀✨
