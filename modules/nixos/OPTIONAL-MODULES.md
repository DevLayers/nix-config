# Optional Enhancements - Usage Guide

This directory contains additional production-grade modules ported from your original config.
All modules are **commented out by default** - enable them as needed in your host configuration.

## 📡 Networking Enhancements (`modules/nixos/networking/`)

### 🚫 blocker.nix - StevenBlack Hosts Blocker

**What:** DNS-level blocking of ads, porn, fakenews, gambling sites
**How:** Updates `/etc/hosts` with StevenBlack's curated blocklist
**Enable:** Uncomment in `networking/default.nix`

```nix
imports = [ ./blocker.nix ];
```

**Categories:** ads, fakenews, gambling, porn, social (customizable)

---

### 🔒 resolved.nix - DNS-over-TLS

**What:** systemd-resolved with encrypted DNS queries
**How:** Uses DNS-over-TLS (DoT) for privacy
**Enable:** Uncomment in `networking/default.nix`

```nix
imports = [ ./resolved.nix ];
```

**Features:**

- DNS-over-TLS encryption
- DNSSEC validation
- Fallback DNS servers
- Link-local multicast name resolution

---

### 📶 network-manager.nix - NetworkManager Config

**What:** NetworkManager with IPv6 and privacy enhancements
**How:** Configures NetworkManager with optimal settings
**Enable:** Uncomment in `networking/default.nix`

```nix
imports = [ ./network-manager.nix ];
```

**Features:**

- IPv6 privacy extensions
- Random MAC addresses
- WiFi powersave disabled (better performance)

---

### 🌐 networking.nix - Base Networking

**What:** Basic networking configuration (hostId, nameservers)
**How:** Sets up fundamental network settings
**Enable:** Uncomment in `networking/default.nix`

```nix
imports = [ ./networking.nix ];
```

---

## ⚙️ System Services (`modules/nixos/services/`)

### 💾 zram.nix - Compressed RAM Swap ⭐ **HIGHLY RECOMMENDED**

**What:** Compresses RAM to effectively increase available memory
**Impact:** ~90% compression ratio = almost 2x effective RAM
**Enable:** Uncomment in `services/default.nix`

```nix
imports = [ ./zram.nix ];
```

**Example:** 16GB RAM → ~28GB effective memory
**Use case:** Essential for systems with limited RAM, reduces disk swapping

---

### 🌡️ thermald.nix - Thermal Management

**What:** Intel thermal daemon for CPU temperature management
**Impact:** Prevents thermal throttling, extends hardware life
**Enable:** Uncomment in `services/default.nix`

```nix
imports = [ ./thermald.nix ];
```

**Note:** Intel CPUs only

---

### 🔄 fwupd.nix - Firmware Updates

**What:** Automatic firmware updates via Linux Vendor Firmware Service
**Impact:** Security updates for UEFI, peripherals, etc.
**Enable:** Uncomment in `services/default.nix`

```nix
imports = [ ./fwupd.nix ];
```

**Commands:**

- `fwupdmgr get-devices` - List updateable devices
- `fwupdmgr refresh` - Refresh firmware metadata
- `fwupdmgr update` - Install updates

---

### ⏰ Time Synchronization (Choose ONE)

#### Option 1: ntpd.nix - Full NTP Daemon

**What:** Traditional NTP daemon with Chrony
**Enable:** Uncomment in `services/default.nix`

```nix
imports = [ ./ntpd.nix ];
```

**Features:** More accurate, suitable for servers

#### Option 2: systemd/timesyncd.nix - Simple Time Sync

**What:** Lightweight systemd-timesyncd
**Enable:** Uncomment in `services/default.nix`

```nix
imports = [ ./systemd/timesyncd.nix ];
```

**Features:** Simpler, sufficient for desktops

---

### 🛡️ systemd/oomd.nix - Out-of-Memory Daemon

**What:** Proactively kills processes before system OOM
**Impact:** Prevents complete system freeze during memory pressure
**Enable:** Uncomment in `services/default.nix`

```nix
imports = [ ./systemd/oomd.nix ];
```

**How it works:** Monitors memory pressure, kills processes before kernel OOM killer

---

## 🎯 Recommended Configurations

### Minimal Desktop

```nix
# modules/nixos/networking/default.nix
imports = [
  ./ssh.nix
  ./firewall
  ./resolved.nix        # DNS-over-TLS for privacy
];

# modules/nixos/services/default.nix
imports = [
  ./zram.nix            # Essential for performance
  ./systemd/timesyncd.nix # Simple time sync
];
```

### Privacy-Focused Desktop

```nix
# modules/nixos/networking/default.nix
imports = [
  ./ssh.nix
  ./firewall
  ./blocker.nix         # Block ads/trackers
  ./resolved.nix        # DNS-over-TLS
  ./network-manager.nix # MAC randomization
];

# modules/nixos/services/default.nix
imports = [
  ./zram.nix
  ./systemd/oomd.nix
  ./systemd/timesyncd.nix
];
```

### Performance Workstation

```nix
# modules/nixos/networking/default.nix
imports = [
  ./ssh.nix
  ./firewall
  ./networking.nix
];

# modules/nixos/services/default.nix
imports = [
  ./zram.nix            # Essential
  ./thermald.nix        # Intel CPUs
  ./fwupd.nix           # Keep firmware updated
  ./ntpd.nix            # Accurate time
  ./systemd/oomd.nix    # Prevent OOM freezes
];
```

### Server Configuration

```nix
# modules/nixos/networking/default.nix
imports = [
  ./ssh.nix
  ./firewall
  ./networking.nix
];

# modules/nixos/services/default.nix
imports = [
  ./zram.nix            # Reduce swap usage
  ./ntpd.nix            # Critical for servers
  ./systemd/oomd.nix    # Prevent OOM
];
```

---

## 📝 Usage in Host Configuration

In your `hosts/yourhost/default.nix`:

```nix
{
  imports = [
    ./hardware-configuration.nix
    "${nixosModules}/common"
    "${nixosModules}/security"
    "${nixosModules}/networking"  # Includes all networking (uncomment modules you want)
    "${nixosModules}/services"    # Includes all services (uncomment modules you want)
    "${nixosModules}/nix"
    "${nixosModules}/fs"
  ];

  # Your host-specific config
  networking.hostName = "yourhost";
}
```

Then edit:

- `modules/nixos/networking/default.nix` - Uncomment networking features
- `modules/nixos/services/default.nix` - Uncomment services

---

## ⚠️ Important Notes

1. **ZRAM is highly recommended** - Almost no downside, significant benefits
2. **Choose only ONE time sync** - Either ntpd OR timesyncd, not both
3. **blocker.nix** - May occasionally block legitimate sites, can customize
4. **thermald** - Intel CPUs only, harmless on AMD but unnecessary
5. **oomd** - May kill important processes under pressure, test first

---

## 🔧 Customization Examples

### Enable ZRAM with custom size

Edit `services/zram.nix`:

```nix
zramSwap = {
  enable = true;
  memoryPercent = 50;  # Use 50% of RAM for ZRAM (default)
};
```

### Customize blocker categories

Edit `networking/blocker.nix`:

```nix
# Available: ads, fakenews, gambling, porn, social
stevenblack = {
  enable = true;
  block = ["ads" "gambling"];  # Only block these
};
```

### Add custom DNS servers to resolved

Edit `networking/resolved.nix`:

```nix
services.resolved = {
  enable = true;
  dnssec = "allow-downgrade";
  extraConfig = ''
    DNS=1.1.1.1 1.0.0.1
    FallbackDNS=8.8.8.8 8.8.4.4
  '';
};
```
