---
title: Initialize LXD
---

# Initialize LXD (`lxd init`)

```bash
lxd init
```
When prompted:
- Would you like to use LXD clustering? (yes/no) [default=no]: `no`
- Do you want to configure a new storage pool? (yes/no) [default=yes]: `yes`
- Name of the new storage pool [default=default]: `sandboxes`
- Would you like to connect to a MAAS server? (yes/no) [default=no]: `no`
- Would you like to create a new local network bridge? (yes/no) [default=yes]: `yes`
- What should the new bridge be called? [default=lxdbr0]: `lxdbr0`
- What IPv4 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]: `auto`
- What IPv6 address should be used? (CIDR subnet notation, "auto" or "none") [default=auto]: `auto`
- Would you like the LXD server to be available over the network? (yes/no) [default=no]: `yes`
- Address to bind LXD to (not including port) [default=all]: `all`
- Port to bind LXD to [default=8443]: `8443`
- Would you like stale cached images to be updated automatically? (yes/no) [default=yes]: `yes`
- Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]: `yes`

> **Note:** At this point a private network bridge (`lxdbr0`) is created with internal container IPs. This will not expose containers to the main network. Optional next step to do that.

### Sample Preseed YAML

Example YAML output:
```yaml
config:
  core.https_address: '[::]:8443'
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  description: ""
  name: lxdbr0
  type: ""
  project: default
storage_pools:
- config:
    source: sandboxes
    pool_name: sandboxes
  description: ""
  name: sandboxes
  driver: zfs
profiles:
- config: {}
  description: ""
  devices:
    eth0:
      name: eth0
      network: lxdbr0
      type: nic
    root:
      path: /
      pool: sandboxes
      type: disk
  name: default
projects: []
cluster: null
```

This config assumes:
- The ZFS pool is named `sandboxes`
- You want the LXD web UI to be accessible over the network on port 8443

