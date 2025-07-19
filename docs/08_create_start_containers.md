---
title: Create & Start Containers
---

# Quick “Hello World” Container Test

Launch a minimal Alpine container to confirm LXD is working:

```bash
lxc launch images:alpine/3.18 alpine-test # Launch a minimal container
lxc exec alpine-test -- /bin/sh # Enter the container
lxc delete alpine-test --force # Delete the container
```

# Create container with stacked profiles
Launch an Ubuntu container using stacked profiles:

```bash
lxc launch ubuntu:22.04 sample-container --profile default --profile default-resources
```
> Note: Ubuntu uses bash: `lxc exec sample-container -- bash`

# Create robust container with GPU support, passwordless SSH and audio passthrough
Note: Audio and GPU profiles require container setup and environment variable passthrough

## Create custom container
Create a container using Ubuntu 22.04 with GPU1 and default resource limits:
> Use `gpu0` if you are *GPU poor*

```bash
lxc init "ubuntu":22.04 sbox-lg-base-container -p ssh-155 -p default-resources -p gpu0 -p audio --no-start
```
> --no-start lets you apply GPU driver version and push files before container boots and installs packages.

### GPU Environment Prep
**Important GPU Driver Consideration**
It is essential to have the container Nvidia driver match the host. 

The host gpu driver may be behind a minor or even major version due to system reboot requirements. Without special consideration the container would download the latest drivers compatible with the GPU. 

Set the host GPU driver version as an environment variable in the container at the time of creation.

```bash
lxc config set sbox-lg-base-container environment.HOST_NVIDIA_DRIVER "$(ssh devbox 'nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1')"
```
> Note: Substitute 'devbox' with your host server's hostname or ip (e.g. 10.0.0.10)

Start the container:

```bash
lxc start sbox-lg-base-container
```

Push ./container_scripts/ to the container
```bash
lxc file push -r ./container_scripts/ sbox-lg-base-container/tmp/
lxc exec sbox-lg-base-container -- bash -c 'chmod -R a+rx /tmp/container_scripts'
```

Shell into the container using 'lxc exec'
```bash
lxc exec sbox-lg-base-container -- bash
```
> The environment variable we set above is only available when use this method.
> In the future, shell in via: `ssh ubuntu@10.0.0.155`

Install base packages
```bash
sudo /tmp/container_scripts/container_custom_image_sbox-lg_install.sh
```

Install GPU support
```bash
sudo /tmp/container_scripts/container_nvidia_install.sh
```
> NOTE: This script will utilize the `$HOST_NVIDIA_DRIVER` set above.
> NOTE: user the optional parameter `upgrade` to uninstall drivers first.


**Verify GPU & Audio:**

Inside container: `nvidia-smi`

Test Audio: `PULSE_SERVER=tcp:10.0.0.254 paplay /tmp/container_scripts/sample.wav`


Optional: Save container as a reusable image then delete container
```bash
lxc publish sbox-lg-base-container --alias sbox-lg-latest
lxc delete sbox-lg-base-container --force
```

> For custom image creation and lifecycle, see [Custom Image Workflow](09_custom_image_workflow.md#build-publish)


# Using Prebuilt Image (sbox-lg)
Now for what you've been waiting for... a fresh container with gpu support, ssh, and audio *in one command!*

You can launch directly from a custom image (e.g. `sbox-lg-latest`)

```bash
lxc launch sbox-lg-latest my-container -p default -p gpu1 -p audio -p default-resources # DHCP
# or
lxc launch sbox-lg-latest my-container -p ssh-150 -p gpu1 -p audio -p default-resources # Static IP
```

> For custom image creation and lifecycle, see [Custom Image Workflow](09_custom_image_workflow.md#build-publish)

