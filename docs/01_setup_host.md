---
title: Host setup
---

# Devbox (Server) Configuration

This section documents the installation and preparation of LXD and ZFS on Devbox. All actions assume Ubuntu Server 22.04 is already installed.

## 1. Install & Refresh LXD
> **Note:** Run `snap list` to check if LXD is already installed.
```bash
sudo snap install lxd
sudo snap refresh lxd
```

## 2. Install ZFS Utilities
> **Note:** Run `zfs --version` to check if ZFS is already installed.
```bash
sudo apt install zfsutils-linux
```

## 3. Create ZFS-backed Storage Pool

This section creates a ZFS-backed LXD storage pool using a sparse file, and sets it to auto-import on boot.

```bash
sudo mkdir -p /data/fast/sandboxes
sudo fallocate -l 100G /data/fast/sandboxes/zfs.img
sudo zpool create sandboxes /data/fast/sandboxes/zfs.img
```
> **Note:** The folder `/data/fast/sandboxes` must exist and be empty before creating the sparse file.

Verify with `zfs list`.

## 4. Persist ZFS Pool Across Reboots

By default, ZFS will **not** auto-import pools backed by `.img` files. To fix this, create a systemd service.

```bash
sudo nano /etc/systemd/system/zfs-import-sandboxes.service
```

Paste the following:

```ini
[Unit]
Description=Import ZFS pool 'sandboxes'
Requires=local-fs.target
After=local-fs.target
RequiresMountsFor=/data/fast/sandboxes

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'zpool list sandboxes || zpool import -d /data/fast/sandboxes sandboxes'

[Install]
WantedBy=multi-user.target
```

Then run:

```bash
sudo systemctl daemon-reload
sudo systemctl enable zfs-import-sandboxes.service
```


## 5. Chain ZFS Import to LXD Start

To ensure LXD waits for the pool before starting:

```bash
sudo systemctl edit snap.lxd.daemon
```

Add this to the override config:

```ini
[Unit]
Requires=zfs-import-sandboxes.service
After=zfs-import-sandboxes.service
```

Then reload:

```bash
sudo systemctl daemon-reexec
sudo systemctl restart snap.lxd.daemon
```


## 6. Verify Storage & LXD Status

```bash
zpool status
lxc storage list
```

Your ZFS pool should now be automatically available after each reboot and ready for use by LXD.

Confirm that `/data/fast/lxd` is mounted and LXD sees the storage backend.

