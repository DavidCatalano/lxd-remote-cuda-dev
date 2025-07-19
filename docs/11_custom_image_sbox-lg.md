---
title: Custom Image: sbox-lg
---

# Sandbox-Large (`sbox-lg`) Image

This is a base container image intended for GPU-intensive and development workloads. It includes useful packages pre-installed for Python, CUDA, audio, and general-purpose usage.

## 1 Purpose & Use-Cases

`sbox-lg` is designed as a reusable base image for projects that require:
- GPU access (CUDA / NVIDIA runtime)
- Audio passthrough
- Python development
- Lightweight CLI tools preinstalled

## 2 Base Image & Required Profiles

- **Base image**: `ubuntu:22.04`
- **Required LXD profiles**:
  - `gpu1` or `gpu-all`
  - `audio`
  - `ssh-<ip>` for remote access
  - `default-resources` (optional limits)

## 3 Package Inventory

| Category      | Packages                                                       | Notes                  |
|---------------|----------------------------------------------------------------|------------------------|
| Core tools    | vim, curl, wget, tmux, tree                                    |                        |
| Dev tools     | build-essential, cmake, pkg-config, ninja-build               |                        |
| VCS           | git, git-lfs                                                   |                        |
| Utilities     | htop, jq, bat                                                  |                        |
| Python        | python3.10, python3.12, pip, venv                              | Dual Python versions   |
| Audio         | pulseaudio, alsa-utils, sox, mpg123, ffmpeg                   | Needed for passthrough |
| GPU / CUDA    | Minimal NVIDIA runtime                                         | cuDNN optional         |

> For image creation, publishing, and usage, see [Custom Image Workflow](09_custom_image_workflow.md#build-publish).

