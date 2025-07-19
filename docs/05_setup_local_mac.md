---
title: Mac Client Setup
---

# Mac Setup (Local Dev Machine)

Install LXC CLI tool to manage containers from your local machine and establish PulseAudio service for microphone and speaker passthrough.

## 1. Install LXC CLI

```bash
brew install lxc
```

> **Note:** On macOS, only the `lxc` client is needed to remotely manage LXD containers. No server installation is required.

Check installation:

```bash
lxc version
```

## 2. Add Devbox as a Remote

```bash
lxc remote add devbox 10.0.0.10 --accept-certificate --password=SuperSecretPassword
lxc remote switch devbox
```

> **Note:** Setting Devbox as the default remote allows you to omit specifying `devbox:` in future commands.

## 3. Usage from Mac

Here are a few essential commands run from the Mac after switching to the Devbox remote context:

```bash
lxc list                        # List containers
lxc launch ubuntu:22.04 mybox   # Launch new container
lxc exec mybox -- bash          # Enter container shell
lxc stop mybox                  # Stop container
lxc delete mybox                # Delete container
```

For a slightly expanded list, including configuration and profile commands, see:
[10 • LXC Command Cheat-Sheet](10_lxc_commands.md)
