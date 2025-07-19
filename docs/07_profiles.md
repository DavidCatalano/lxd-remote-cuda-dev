---
title: LXD Profiles
---

# LXD Profiles Overview

LXD profiles are reusable sets of container configuration like devices, resource limits, and environment settings. Profiles can be **stacked** when launching a container, merging behaviors like GPU passthrough, networking, audio, or CPU/memory caps without duplication.

View `./container_profiles/` for the latest YAML examples.

## Index of Existing Profiles

**Networking**
- `default` – Default profile enables DHCP
- `ssh-15[0-5]` – Assigns static IP and injects SSH keys via cloud-init
- `br0` – System-level profile used during one-time setup enabling static IP

**Hardware Limits**
- `default-resources` – Provides baseline CPU/RAM/disk limits

**GPU**
- `gpu-all` – Exposes all GPUs to container
- `gpu0` – Exposes first GPU
- `gpu1` – Exposes second GPU
- `gpu1-pcie` – Alternative passthrough method using PCI ID (advanced)

**Other**
- `audio` – Adds PulseAudio passthrough support (see [Audio Passthrough](06_audio_passthrough.md))

# LXD Profiles Setup

## Listing and Verifying Profiles

```bash
lxc profile list
lxc profile show <profile-name>
```

## Creating and Applying Profiles

```bash
lxc profile create <profile-name>
lxc profile edit <profile-name>
```

Or apply directly from file:

```bash
lxc profile edit <profile-name> < ./container_profiles/<profile-name>.yaml
```

Optional: import all SSH profiles at once from ./container_profiles

```bash
for f in ./container_profiles/ssh-*.yaml; do lxc profile create "$(basename "${f%.yaml}")" < "$f"; done
```

# Example LXD Profiles and Important Notes

## Example GPU Profile

Passthrough individual GPUs selectively or expose all using the LXD bindings approach. See `./container-profiles/gpu1-pcie.yaml` for a low-level alternative approach.

Create and edit:

```bash
lxc profile create gpu1
lxc profile edit gpu1
```

YAML:

```yaml
name: gpu1
description: Use only GPU 1 (via LXD managed device)
config: {}
devices:
  gpu1:
    id: "1"
    type: gpu
```

## Example audio Profile

Pass through microphone and speaker access via PulseAudio socket sharing:

Create and edit:

```bash
lxc profile create audio
lxc profile edit audio
```

YAML:

```yaml
config:
  environment.PULSE_SERVER: unix:/tmp/pulse-native
  raw.idmap: "both 1000 1000"
description: "Passthrough audio devices"
devices:
  pulse:
    path: /tmp/pulse-native
    source: /tmp/pulse-native
    type: disk
name: audio
```

> **Note:** Requires exposing `/tmp/pulse-native` from the host's PulseAudio.

## Example default-resources Profile

Baseline CPU, memory, and disk settings:

Create and edit:

```bash
lxc profile create default-resources
lxc profile edit default-resources
```

YAML:

```yaml
config:
  limits.cpu: "16"
  limits.memory: 16GB
  limits.disk.priority: "5"
description: "Default resource limits for containers"
devices: {}
name: default-resources
```

## Example Static IP and SSH Profile (ssh-150)

Assigns a static IP and injects an SSH key into the container via cloud-init. Requires the container to use the `br0` network (see [Setup Networking](03_setup_networking.md)).

Create and edit:

```bash
lxc profile create ssh-150
lxc profile edit ssh-150
```

YAML:

```yaml
config:
  user.user-data: |
    #cloud-config
    users:
      - name: ubuntu
        ssh-authorized-keys:
          - ssh-rsa AAAAB3Nza...your-mac-key...
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: sudo
        shell: /bin/bash
description: Assign static IP 10.0.0.150 and enable SSH
devices:
  eth0:
    name: eth0
    network: br0
    type: nic
name: ssh-150
```
