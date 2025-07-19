---
title: Host Networking
---

# Networking

This section covers how to configure container networking via LXD. It includes both the default managed bridge (`lxdbr0`) and a host-attached LAN bridge (`br0`) suitable for static IPs and remote access.

## 1. Default `lxdbr0` Bridge

When LXD is initialized without a custom network bridge, it creates a default bridge:

```bash
lxc network list
```

Typical output:

```
+--------+----------+---------+----------------+------+-------------+
|  NAME  |   TYPE   | MANAGED |      IPV4      | IPV6 | DESCRIPTION |
+--------+----------+---------+----------------+------+-------------+
| lxdbr0 | bridge   | YES     | 10.175.31.1/24 | none |             |
+--------+----------+---------+----------------+------+-------------+
```

This bridge uses NAT and assigns private addresses. It's ideal for testing and local-only workloads.

## 2. Create LAN Bridge (`br0`) for Static IP Containers

If you want containers to have static IPs on your home LAN and be reachable from other devices (e.g., for SSH or VS Code), create a bridge attached to your **Ethernet NIC** (not your Wi-Fi interface).

### System-Managed Bridge with Netplan (Required for host access)

1. **Create netplan configuration** `/etc/netplan/99-br0-static.yaml`:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1: {}
  bridges:
    br0:
      interfaces: [eno1]
      addresses: [10.0.0.10/24]
      nameservers:
        addresses: [1.1.1.1, 1.0.0.1]
      routes:
        - to: default
          via: 10.0.0.1
```

2. **Apply the configuration**:
```bash
sudo netplan apply
```

3. **LXD will automatically detect the system bridge** when you try to use it. No need to manually import it.

> Replace `eno1` with your actual NIC name:
> 
> ```bash
> ip -br a
> ```

### Create a profile using this bridge

When using a system-managed bridge, the device configuration syntax is different:

```bash
lxc profile create lan-bridge
lxc profile device add lan-bridge eth0 nic nictype=bridged parent=br0
```

Or define it manually:

```yaml
config: {}
description: LAN bridge on br0
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: br0
    type: nic
name: lan-bridge
```

## 3. Enable Docker Container Access (if using Docker)

If you have Docker installed and need containers accessible from the LAN, you'll need to add iptables rules:

```bash
# Allow forwarding between br0 and Docker bridges
sudo iptables -I FORWARD -i br0 -o br+ -j ACCEPT
sudo iptables -I FORWARD -i br+ -o br0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Make rules persistent
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

## 4. Verify the Configuration

After configuration:

```bash
# Check br0 has its IP
ip addr show br0 | grep inet

# Check eno1 is enslaved to br0
ip addr show eno1

# Check default routes
ip route | grep default

# Check LXD bridge configuration
lxc network show br0
```

Expected output:
- br0 has IP 10.0.0.10/24
- eno1 shows `master br0` (enslaved to bridge)
- Default route via 10.0.0.1 on br0

## Troubleshooting

### Containers not getting LAN IPs

Ensure the container profile uses br0 with the correct syntax:
```bash
lxc profile show default | grep -A5 devices
```

For system-managed bridges, the device should show:
```yaml
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: br0
    type: nic
```

### Host loses connectivity after bridge setup

Check for conflicting netplan files:
```bash
ls /etc/netplan/
grep -r "eno1" /etc/netplan/
```

Remove or disable conflicting configurations like cloud-init:
```bash
sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.disabled
```

### Docker containers not accessible from LAN

Check iptables FORWARD chain:
```bash
sudo iptables -L FORWARD -n -v
```

The default policy should allow traffic between br0 and Docker bridges (br-*).

### Important Notes

- **System-managed is required**: When you want the host to have an IP on the bridge, you must use netplan to manage it
- **Bridge IP Assignment**: In a bridge setup, the IP goes on the bridge (br0), NOT on the enslaved interface (eno1)
- **Netplan Conflicts**: Ensure only one netplan file configures each interface - especially watch for cloud-init files
- **WiFi Bridges**: Bridging typically doesn't work with WiFi adapters due to 802.11 limitations
- **LXD Unmanaged Bridges**: When using system-managed bridges, LXD sees them as "unmanaged" (managed: false)
- **Device Configuration**: For unmanaged bridges, use `nictype=bridged parent=br0` instead of `network=br0`

This approach ensures both LXD containers and the host can use the same network bridge for LAN access.