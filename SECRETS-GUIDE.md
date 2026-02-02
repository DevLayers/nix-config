# Secrets Management Guide - Agenix Integration

This guide shows how to manage encrypted secrets (passwords, API keys, SSH keys, certificates) in your NixOS configuration using **agenix**.

---

## 🔐 **What is Agenix?**

**Agenix** encrypts secrets with SSH keys and decrypts them during NixOS activation. Secrets are:

- ✅ Stored encrypted in Git (safe to push to public repos)
- ✅ Decrypted only on authorized machines
- ✅ Available to services at runtime

---

## 📋 **Quick Start - 5 Steps**

### **Step 1: Generate SSH Key for Secrets (if you don't have one)**

```bash
# On your main machine
ssh-keygen -t ed25519 -f ~/.ssh/agenix -C "agenix-secrets"

# Copy public key for later
cat ~/.ssh/agenix.pub
# Example output: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx... agenix-secrets
```

---

### **Step 2: Create `secrets/secrets.nix` (Secret Definitions)**

```nix
# secrets/secrets.nix
let
  # Your user's SSH public keys (from ~/.ssh/agenix.pub)
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx... agenix-secrets";

  # Your system's host SSH public keys (from /etc/ssh/ssh_host_ed25519_key.pub)
  milkyway = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx... root@milkyway";
  andromeda = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFx... root@andromeda";

  # Groups (who can decrypt which secrets)
  allUsers = [ user1 ];
  allSystems = [ milkyway andromeda ];
  everyone = allUsers ++ allSystems;
in
{
  # Define your secrets here
  # Format: "path/to/secret.age".publicKeys = [ key1 key2 ... ];

  "spotify-password.age".publicKeys = everyone;
  "tailscale-auth-key.age".publicKeys = everyone;
  "wifi-password.age".publicKeys = [ user1 milkyway ];  # Only milkyway laptop
  "github-token.age".publicKeys = [ user1 andromeda ];  # Only andromeda server
}
```

---

### **Step 3: Create and Encrypt Secret Files**

```bash
# Install agenix CLI tool
nix profile install nixpkgs#agenix

# Create a secret (will open $EDITOR)
cd /home/xi/nixos-configs/nix-config-alexnabokikh
agenix -e secrets/spotify-password.age

# Type your secret, save and exit
# Example: myspotifypassword123

# The file is now encrypted! Safe to commit to git.
```

**Alternative - Encrypt existing file:**

```bash
# Encrypt an existing plaintext file
cat my-secret.txt | agenix -e secrets/my-secret.age
```

---

### **Step 4: Use Secrets in Your Configuration**

#### **Example 1: Simple Secret File**

```nix
# hosts/milkyway/default.nix or any module
{ config, customLib, ... }:
{
  # Decrypt secret to /run/agenix/spotify-password at boot
  age.secrets.spotify-password = customLib.mkAgenixSecret {
    file = ../../secrets/spotify-password.age;
  };

  # Use it in a service
  systemd.services.spotify = {
    script = ''
      password=$(cat ${config.age.secrets.spotify-password.path})
      spotify-login --password="$password"
    '';
  };
}
```

---

#### **Example 2: Secret with Custom Owner/Permissions**

```nix
# For a service running as specific user
age.secrets.nextcloud-admin-pass = customLib.mkAgenixSecret {
  file = ../../secrets/nextcloud-admin-pass.age;
  owner = "nextcloud";
  group = "nextcloud";
  mode = "0400";  # Read-only for owner
};

# Use in nextcloud config
services.nextcloud = {
  config.adminpassFile = config.age.secrets.nextcloud-admin-pass.path;
};
```

---

#### **Example 3: SSH Private Key Secret**

```nix
age.secrets.github-deploy-key = customLib.mkAgenixSecret {
  file = ../../secrets/github-deploy-key.age;
  path = "/home/myuser/.ssh/github_deploy";
  owner = "myuser";
  mode = "0600";
};
```

---

#### **Example 4: Environment Variable from Secret**

```nix
age.secrets.api-token = customLib.mkAgenixSecret {
  file = ../../secrets/api-token.age;
};

systemd.services.my-app = {
  environment = {
    API_TOKEN_FILE = config.age.secrets.api-token.path;
  };
  script = ''
    export API_TOKEN=$(cat $API_TOKEN_FILE)
    my-app --token="$API_TOKEN"
  '';
};
```

---

### **Step 5: Get Host SSH Public Key (For New Machines)**

```bash
# On the target machine (after NixOS installation)
ssh-keyscan localhost | grep ssh-ed25519

# Or directly from file
cat /etc/ssh/ssh_host_ed25519_key.pub

# Add this to secrets/secrets.nix under "allSystems"
```

---

## 🔧 **Advanced: Conditional Secrets (Per-Host)**

```nix
# modules/nixos/secrets/default.nix (already configured)
{ config, customLib, ... }:
{
  age.identityPaths = [
    "/home/myuser/.ssh/agenix"      # User key
    "/etc/ssh/ssh_host_ed25519_key" # System key
  ];

  # Conditionally enable secrets based on hostname
  age.secrets = customLib.mkIf (config.networking.hostName == "milkyway") {
    wifi-password = customLib.mkAgenixSecret {
      file = ../../secrets/wifi-password.age;
    };
  };
}
```

---

## 📂 **Directory Structure**

```
nix-config-alexnabokikh/
├── flake.nix              # Agenix input already added
├── secrets/
│   ├── secrets.nix        # Define who can decrypt what (CREATE THIS)
│   ├── spotify-password.age
│   ├── tailscale-auth-key.age
│   ├── wifi-password.age
│   └── github-token.age
├── modules/nixos/secrets/
│   └── default.nix        # Agenix configuration (ALREADY EXISTS)
└── hosts/milkyway/
    └── default.nix        # Use secrets here
```

---

## 🛠️ **Common Use Cases**

### **1. Tailscale Auth Key**

```nix
age.secrets.tailscale-auth = customLib.mkAgenixSecret {
  file = ../../secrets/tailscale-auth-key.age;
};

services.tailscale.authKeyFile = config.age.secrets.tailscale-auth.path;
```

### **2. WiFi Password**

```nix
age.secrets.wifi-password = customLib.mkAgenixSecret {
  file = ../../secrets/wifi-password.age;
};

networking.wireless.networks."MyNetwork".pskRaw =
  builtins.readFile config.age.secrets.wifi-password.path;
```

### **3. Database Password**

```nix
age.secrets.db-password = customLib.mkAgenixSecret {
  file = ../../secrets/db-password.age;
  owner = "postgres";
};

services.postgresql.initialScript = pkgs.writeText "init.sql" ''
  ALTER USER postgres PASSWORD '$(cat ${config.age.secrets.db-password.path})';
'';
```

---

## 🔑 **Helper Function: `customLib.mkAgenixSecret`**

Already configured in `lib/secrets.nix`. Usage:

```nix
customLib.mkAgenixSecret {
  file = path;           # Path to .age file (REQUIRED)
  owner = "root";        # File owner (optional)
  group = "root";        # File group (optional)
  mode = "0400";         # Permissions (optional)
  path = null;           # Custom path (optional, default: /run/agenix/<name>)
  name = null;           # Custom name (optional)
  symlink = true;        # Create symlink (optional)
}
```

---

## 🚨 **Important Notes**

1. **NEVER commit `.age` files to git before encrypting!**

   - Use `agenix -e` to create encrypted files
   - Encrypted `.age` files are safe to commit

2. **Backup your SSH private keys!**

   - If you lose `~/.ssh/agenix`, you can't decrypt secrets
   - Store backup in password manager or encrypted USB

3. **Host keys are generated during NixOS installation**

   - Get them with `cat /etc/ssh/ssh_host_ed25519_key.pub`
   - Add to `secrets/secrets.nix` BEFORE encrypting secrets for that host

4. **Secrets are decrypted at boot**

   - Available in `/run/agenix/` after system activation
   - Stored in tmpfs (RAM) - wiped on reboot

5. **Re-keying (changing who can decrypt)**
   ```bash
   # After modifying secrets/secrets.nix
   agenix --rekey
   ```

---

## 📖 **Full Example: Complete Setup**

```nix
# secrets/secrets.nix
let
  user = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKx... agenix-secrets";
  milkyway = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHx... root@milkyway";
in
{
  "spotify-password.age".publicKeys = [ user milkyway ];
  "tailscale-auth.age".publicKeys = [ user milkyway ];
}
```

```bash
# Create secrets
agenix -e secrets/spotify-password.age  # Type: mypassword123
agenix -e secrets/tailscale-auth.age    # Paste: tskey-auth-xxx
```

```nix
# hosts/milkyway/default.nix
{ config, customLib, ... }:
{
  age.secrets.spotify-password = customLib.mkAgenixSecret {
    file = ../../secrets/spotify-password.age;
  };

  age.secrets.tailscale-auth = customLib.mkAgenixSecret {
    file = ../../secrets/tailscale-auth.age;
  };

  services.tailscale.authKeyFile = config.age.secrets.tailscale-auth.path;
}
```

```bash
# Rebuild
sudo nixos-rebuild switch --flake .#milkyway
```

---

## ✅ **Your Setup is Ready!**

The agenix infrastructure is already configured in your migrated config:

- ✅ Agenix input in `flake.nix`
- ✅ `lib/secrets.nix` with `mkAgenixSecret` helper
- ✅ `modules/nixos/secrets/default.nix` with identity paths
- ✅ Now imported in `common/default.nix`

**Next steps:**

1. Create `secrets/secrets.nix` (copy template above)
2. Run `agenix -e secrets/your-secret.age`
3. Use in config with `customLib.mkAgenixSecret`
4. Rebuild!

**Resources:**

- [Agenix Documentation](https://github.com/ryantm/agenix)
- [Your lib/secrets.nix](lib/secrets.nix) - Helper function source
