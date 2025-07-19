---
title: LXC Command Cheat-Sheet
---

# 12 Useful LXC Command Cheat-Sheet

## Container Lifecycle

```bash
lxc launch <image> <name>       # Create new container
lxc list                        # Show running/stopped containers
lxc stop <name>                 # Stop container
lxc start <name>                # Start container
lxc delete <name>               # Delete container
lxc restart <name>              # Restart container
```

## Shell Access & Execution

```bash
lxc exec <name> -- bash         # Open interactive shell
lxc exec <name> -- <command>    # Run one-off command
```

## Configuration & Info

```bash
lxc info <name>                 # Container info
lxc config show <name>          # Show container config
lxc config show <name> --expanded  # Merged profile view
```

## File Copy

```bash
lxc file push local.txt <name>/root/    # Push to container
lxc file pull <name>/root/remote.txt .  # Pull from container
```

## Profiles

```bash
lxc profile list
lxc profile show <profile>
lxc profile edit <profile>
lxc profile assign <name> <profiles...>
lxc profile add <name> <profile>
lxc profile remove <name> <profile>
```

## Networking

```bash
lxc network list
lxc network show br0
lxc network create br0 ...
```

## Storage

```bash
lxc storage list
lxc storage show <pool>
```

## Images

```bash
lxc image list
lxc image delete <alias>
lxc image alias list
```

## Snapshots
```bash
lxc restore s2s-sandbox snap1 # Restore to the Original Container
lxc copy s2s-sandbox/snap1 s2s-sandbox-snap1 # Create a New Container from a Snapshot
lxc publish s2s-sandbox/snap1 --alias s2s-sandbox-image # Convert a Snapshot to an Image
```

## Remote Hosts

```bash
lxc remote list
lxc remote add <name> <ip>:8443 --accept-certificate --password=...
lxc remote switch <name>
```

> Tip: Use `lxc help` to list all commands.

