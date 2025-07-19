# lxd-remote-cuda-dev

A comprehensive setup guide for containerized remote development environments using LXD on Ubuntu, with NVIDIA GPU passthrough for CUDA development. Designed for developers who need access to high-performance computing resources from lightweight client machines.

## Use Cases

- **CUDA development from macOS** - Access NVIDIA GPUs for machine learning, data science, and compute workloads from your MacBook
- **Clean project isolation** - Test and develop without polluting your local environment
- **Reproducible dev environments** - Create, snapshot, and share standardized setups across teams
- **GPU-intensive applications** - Run CUDA workloads remotely without impacting local machine performance
- **Custom container workflows** - Maintain clean environments for Docker development and testing

## What This Guide Provides

- **LXD containerization** with NVIDIA GPU passthrough
- **Container snapshots** using ZFS storage backend
- **Pre-configured profiles** for different development needs
- **Audio passthrough** for applications requiring sound
- **Remote access** via SSH and web UI
- **Standardized workflows** for creating and managing custom images

## Documentation Index

### Core Setup
1. [Host Setup](docs/01_setup_host.md)
2. [Initialize LXD](docs/02_initialize_lxd.md)
3. [Networking Configuration](docs/03_setup_networking.md)
4. [Remote Access & Web UI](docs/04_remote_access_webui.md)
5. [Local Mac/Linux Client Setup](docs/05_setup_local_mac.md)

### Container Configuration & Usage
6. [Audio Passthrough](docs/06_audio_passthrough.md)
7. [LXD Profiles](docs/07_profiles.md)
8. [Creating & Starting Containers](docs/08_create_start_containers.md)
9. [Custom Image Workflow](docs/09_custom_image_workflow.md)
10. [LXC Command Reference](docs/10_lxc_commands.md)
11. [Custom Image Details: `sbox-lg`](docs/11_custom_image_sbox-lg.md)

### Appendices
- [Passwordless SSH](docs/99_appendix_passwordless_ssh.md)
- [Python Development with VS Code](docs/99_appendix_python_dev_setup.md)
- [Docker in LXC](docs/99_appendix_docker_in_lxc.md)
- [Developer Environment Setup](docs/99_appendix_dev_env_setup.md)

## Configuration Notes

This documentation originated as internal setup notes, so you'll need to update several environment-specific values:

- **Server name:** References to `Devbox`
- **IP addresses:** Primary server (`10.0.0.10`), client placeholder (`10.0.0.254`), static IP container range (`10.0.0.150-155`)
- **Container Username:** Default `ubuntu` user
- **SSH keys:** Placeholder keys in `ssh-*.yaml` profiles
- **Network interface:** `eno1` in bridge configuration
- **Storage:** ZFS pool path `/data/fast/sandboxes/zfs.img`

## Contributing

Contributions, bug reports, and suggestions are welcome. Please open an issue or submit a pull request.