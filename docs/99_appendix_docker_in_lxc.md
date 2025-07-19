---
title: Docker Containers in LXC Containers
---

## Docker (container in container config)

Run the following commands to enable Docker use w/in a container:

```bash
# Install Docker
`lxc exec litellm-proxy -- apt-get update`
`lxc exec litellm-proxy -- apt install docker.io docker-compose`

# Enable nested containers
lxc config set litellm-proxy security.nesting true

# Likely also need privileged mode for cgroup access
lxc config set litellm-proxy security.privileged true

# Restart container to apply changes
lxc restart litellm-proxy

# Add 'ubuntu' to 'docker' group
lxc exec litellm-proxy -- usermod -aG docker ubuntu
```