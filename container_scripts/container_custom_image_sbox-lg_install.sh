#!/bin/bash

# Sandbox Large (sbox-lg) Bootstrap Install Script
# Purpose: Configure base container with essential packages for dev and ML workloads

set -euo pipefail

# Update system packages
apt update && apt upgrade -y

# Install core tooling
apt install -y \
  software-properties-common \
  gnupg \
  vim \
  wget \
  curl \
  zip \
  unzip \
  btop \
  tree \
  tmux \
  bat

# Symlink batcat to bat if not already linked
if [ ! -e /usr/local/bin/bat ]; then
  ln -s /usr/bin/batcat /usr/local/bin/bat
fi

# Install dev tools
apt install -y \
  build-essential \
  cmake \
  pkg-config

# Install misc tools
apt install -y \
  git \
  git-lfs \
  pulseaudio-utils \
  jq

# Install python and uv
apt install -y python3 python3-pip python3-venv
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh


# Clean up
apt autoremove -y
apt clean

echo -e "\n[Installation Complete]\n"