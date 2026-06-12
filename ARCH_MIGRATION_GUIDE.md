# 🚀 NixOS to Arch Linux Migration Guide (with ArchEclipse)

This guide provides a comprehensive roadmap for moving from your production-hardened NixOS configuration to Arch Linux while adopting the **ArchEclipse** desktop environment and retaining your **Nix/Home Manager** workflow.

---

## 🏗️ Phase 1: Arch Linux Base Installation

1.  **Install Arch Linux**:
    *   Use the [archinstall](https://wiki.archlinux.org/title/archinstall) script or follow the [Installation Guide](https://wiki.archlinux.org/title/Installation_guide).
    *   **Filesystem**: Stick with **BTRFS** (as used in your Nix config) to keep your library helpers (`lib/fs.nix`) relevant.
2.  **Essential Packages**:
    ```bash
    sudo pacman -S git python base-devel networkmanager bluez bluez-utils
    ```

---

## ❄️ Phase 2: Installing Nix & Home Manager

On Arch, Nix runs as a multi-user daemon alongside `pacman`.

1.  **Install Nix**:
    ```bash
    sudo pacman -S nix
    sudo systemctl enable --now nix-daemon.service
    sudo gpasswd -a $USER nix-users
    # RE-LOG for group changes to take effect
    ```
2.  **Enable Flakes**:
    Edit `/etc/nix/nix.conf` or `~/.config/nix/nix.conf`:
    ```conf
    experimental-features = nix-command flakes
    ```
3.  **Install Home Manager**:
    You can use your existing flake to initialize Home Manager. You'll need to update your `flake.nix` to support a standalone Home Manager configuration on Arch.

---

## 🎨 Phase 3: Deploying ArchEclipse

**ArchEclipse** will handle your GUI (Hyprland, AGS, Waybar, Theming).

1.  **Run the Installer**:
    ```bash
    python3 <(curl -fsSL https://raw.githubusercontent.com/AymanLyesri/ArchEclipse/refs/heads/master/.config/hypr/maintenance/install.py)
    ```
2.  **Nix Conflict Prevention**:
    *   ArchEclipse manages `~/.config/hypr` and `~/.config/ags`.
    *   **Crucial**: Do NOT manage these paths via Home Manager `xdg.configFile` initially. Let ArchEclipse own them, or you will break the automatic updates and dynamic theming.

---

## 🛡️ Phase 4: Porting NixOS Hardening to Arch

Arch does not have a declarative `boot.kernel.sysctl` module. You must port your `security/kernel.nix` manually.

### 1. Kernel Hardening (Sysctl)
Create `/etc/sysctl.d/99-nixos-hardened.conf` and paste the values from your `modules/nixos/security/kernel.nix`.
*   *Key values to include*: `kernel.unprivileged_userns_clone=0`, `kernel.yama.ptrace_scope=3`, `net.ipv4.tcp_congestion_control=bbr`.

### 2. Blacklisted Modules
Create `/etc/modprobe.d/nixos-blacklist.conf`:
```conf
# Obscure protocols
blacklist dccp
blacklist sctp
# ... copy others from your kernel.nix blacklist ...
```

### 3. SSH Hardening
Your `networking/ssh.nix` is very strict. Manually update `/etc/ssh/sshd_config`:
*   **Port**: `30`
*   **KexAlgorithms**: Copy the list from your Nix config.
*   **Authentication**: `PasswordAuthentication no`, `PubkeyAuthentication yes`.

---

## 🛠️ Phase 5: Adapting your Flake for Arch

Your current `flake.nix` is optimized for NixOS hosts. To use it on Arch:

1.  **Update `homeConfigurations`**:
    Ensure your `mkHomeConfiguration` uses the correct `system` (likely `x86_64-linux`).
2.  **Handle Graphics (`nixGL`)**:
    Arch Linux apps and Nix apps use different OpenGL drivers. Nix apps won't find Arch's drivers.
    *   Add [nixGL](https://github.com/nix-community/nixGL) to your flake inputs.
    *   Wrap GUI apps in your `home.packages`:
        ```nix
        # Example alias in zsh
        alias zen="nixGL zen-browser"
        ```

---

## 🏗️ Phase 6: Development Templates & Workflow

Your 20+ templates (Rust, Python, Go, DevOps-Complete) are fully portable but require a few Arch-specific steps to feel "native."

### 1. Register your Local Flake
To use `nix flake init -t config#rust` from anywhere on your system, register your local repository:
```bash
nix registry add config git+file:///home/sarw/nix-config
```
*Now you can use `nix flake init -t config#<template-name>` in any directory.*

### 2. Install Direnv & Nix-Direnv
Your templates (like `devops-complete`) rely on `.envrc` for automatic environment loading.
1.  **Install via Pacman**:
    ```bash
    sudo pacman -S direnv
    ```
2.  **Configure Zsh** (via Home Manager or manually):
    Add `eval "$(direnv hook zsh)"` to your `.zshrc`.
3.  **Use nix-direnv**: Ensure your `.envrc` contains `use flake` or `use nix`.

### 3. XDG Environment Stability
Your templates (especially Python) export many XDG variables (e.g., `PYTHONPYCACHEPREFIX`).
*   **Warning**: If you use Arch-native Python alongside Nix-managed Python, these variables might cause conflicts.
*   **Fix**: Always run your dev tools inside a `nix develop` shell or via `direnv` to keep the environment isolated.

### 4. Port Custom Scripts & Environment
Your `modules/home-manager/scripts/bin` scripts (like `ks`, `asg-getter`, `traverser`) will work perfectly on Arch.
*   **Editor Defaults**: Port your `NVIM` defaults (MANPAGER, PAGER, etc.) from `modules/nixos/common/default.nix` to your Home Manager shell config.
*   **Virtual Camera**: If you used the `v4l2loopback` virtual camera, install it via Pacman: `sudo pacman -S v4l2loopback-dkms`.

### 5. Hardware & System Services
Your NixOS config had advanced Bluetooth and Audio tuning. To replicate this on Arch:
1.  **PipeWire & Bluetooth Codecs**:
    Install `pipewire`, `wireplumber`, and codecs:
    ```bash
    sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber libldac
    ```
    *Copy your `bluetoothEnhancements` and `bluetoothRules` logic from `nixos/common/default.nix` to `~/.config/wireplumber/wireplumber.conf.d/`.*
2.  **Bangla Font Support**:
    Ensure your native Arch setup includes the fonts from your Nix config:
    ```bash
    sudo pacman -S noto-fonts noto-fonts-emoji otf-lohit-bengali ttf-jetbrains-mono-nerd
    ```
3.  **Podman Rootless**:
    To keep Podman working without root (as in your `users.users.sarw` config), you must manually set up subUIDs/subGIDs:
    ```bash
    echo "sarw:100000:65536" | sudo tee -a /etc/subuid
    echo "sarw:100000:65536" | sudo tee -a /etc/subgid
    ```

---

## 🖥️ A Note on KDE vs. ArchEclipse
You mentioned migrating to **KDE**, but the configuration you linked (**ArchEclipse**) is built for **Hyprland**.
*   **Option A (Hyprland)**: Follow the ArchEclipse installer. Your Home Manager config will theme your terminal and CLI, while ArchEclipse handles the windows and bar.
*   **Option B (KDE)**: Install KDE (`sudo pacman -S plasma`). You can then use the [plasma-manager](https://github.com/pjones/plasma-manager) Home Manager module to keep your KDE settings declarative.
*   **My Recommendation**: Use ArchEclipse (Hyprland) as your primary "productive" environment, but keep KDE installed as a fallback. Both can coexist on Arch easily.

---

## 🔄 Summary of Workflow Changes

| Feature | NixOS Method | Arch + Nix Method |
| :--- | :--- | :--- |
| **System Updates** | `nixos-rebuild switch` | `pacman -Syu` |
| **User Config** | `home-manager switch` | `home-manager switch --flake .#user@host` |
| **Security** | Declarative Nix Modules | `/etc/sysctl.d/` + `/etc/modprobe.d/` |
| **Desktop Environment** | Nix-managed Hyprland | ArchEclipse (Git-managed) |
| **New Apps** | Add to `flake.nix` | `pacman -S` (System) OR `flake.nix` (User) |

## ⚠️ Important Considerations
*   **Agenix**: You can still use `agenix` on Arch. It will decrypt secrets to `/run/user/$UID/agenix/` or a custom path.
*   **NixOS Library Helpers**: Your `lib/dag.nix` and `lib/xdg.nix` remain highly useful for complex Home Manager setups.
*   **Catppuccin**: Since you use `catppuccin/nix`, this will continue to theme your CLI tools (bat, starship, etc.) seamlessly on Arch.
