---
title: Audio Passthrough (PulseAudio)
---

# 8 Audio Passthrough (PulseAudio)

PulseAudio is a sound server that enables audio streaming between computers on a network. It allows for routing audio between containers and hosts with fine-grained control over input and output devices.

## PulseAudio Network Audio Setup

### Setup PulseAudio

This repository includes a script called `local-audio.sh` that helps you manage PulseAudio on your Mac for streaming audio to/from containers.

#### Usage

```bash
./local-audio.sh [start|stop|status]
```

#### Commands

- `start` - Start PulseAudio with network module configured
- `stop` - Stop PulseAudio
- `status` - Check PulseAudio status

#### Configuration

The script is configured with the following default settings:

- `DEVBOX_IP="10.0.0.10"` - IP address of remote container server
- `TIMEOUT=600` - Idle timeout in seconds (10 minutes)

You can modify these values directly in the `local-audio.sh` file if needed.

### Container Configuration

The corresponding container profile 'audio' should be configured as follows:

```yaml
name: audio
description: Forward container audio to remote PulseAudio server (Mac)
config:
  environment.PULSE_SERVER: tcp:10.0.0.254     # <-- Your Mac's IP here
  raw.idmap: both 1000 1000
devices: {}
```

### Testing Audio

To test audio from your container to your Mac, run:

```bash
# On your host or from your mac
lxc file push sample.wav sandbox-alpha/tmp/container_scripts/
```

```bash
# On your devbox container (enter your mac IP)
PULSE_SERVER=tcp:10.0.0.254 paplay /tmp/container_scripts/sample.wav
```
