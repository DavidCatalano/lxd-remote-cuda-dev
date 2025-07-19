#!/bin/bash

# container_nvidia_install.sh
# Purpose: Install NVIDIA driver inside LXD container to match host driver version via env var
# Usage: ./container_nvidia_install.sh [upgrade]
#        If "upgrade" parameter is passed, existing NVIDIA drivers will be uninstalled first

set -e

# Check if upgrade parameter was passed
UPGRADE_MODE=false
if [ "$1" = "upgrade" ]; then
    UPGRADE_MODE=true
    echo "Running in upgrade mode - will uninstall existing NVIDIA drivers first"
fi

# Check environment variable passed from host
if [ -z "$HOST_NVIDIA_DRIVER" ]; then
    echo "[Error] HOST_NVIDIA_DRIVER env var not set."
    echo "You must run the following before starting the container:"
    echo "lxc config set sandbox-alpha environment.HOST_NVIDIA_DRIVER \"\$(ssh devbox 'nvidia-smi --query-gpu=driver_version --format=csv,noheader | head -n1')\""
    exit 1
fi

NVIDIA_FULL_VERSION="$HOST_NVIDIA_DRIVER"
NVIDIA_MAJOR_VERSION=$(echo "$NVIDIA_FULL_VERSION" | cut -d. -f1)
DRIVER_SHORT_VERSION=${NVIDIA_FULL_VERSION//./-}  # Convert 570.144 -> 570-144

echo "Detected NVIDIA driver version from env: $NVIDIA_FULL_VERSION"

# Uninstall existing NVIDIA drivers if in upgrade mode
if [ "$UPGRADE_MODE" = true ]; then
    echo "Uninstalling existing NVIDIA drivers..."
    
    # Find and remove existing NVIDIA packages
    NVIDIA_PACKAGES=$(dpkg -l | grep -i nvidia | awk '{print $2}')
    if [ -n "$NVIDIA_PACKAGES" ]; then
        echo "Found the following NVIDIA packages to uninstall:"
        echo "$NVIDIA_PACKAGES"
        
        # Use apt to remove all NVIDIA packages
        apt purge -y $NVIDIA_PACKAGES
        apt autoremove -y
        
        echo "Existing NVIDIA drivers uninstalled successfully"
    else
        echo "No existing NVIDIA packages found to uninstall"
    fi
fi

# Add NVIDIA CUDA keyring
curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub | \
    gpg --dearmor -o /usr/share/keyrings/nvidia-cuda-keyring.gpg

# Add the NVIDIA repository securely
echo "deb [signed-by=/usr/share/keyrings/nvidia-cuda-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /" \
    > /etc/apt/sources.list.d/cuda.list

# Pin priority to prefer NVIDIA repo
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600

apt update

# Package names to install
PKGS=(
    "nvidia-utils-${NVIDIA_MAJOR_VERSION}"
    "libnvidia-compute-${NVIDIA_MAJOR_VERSION}"
    "libnvidia-decode-${NVIDIA_MAJOR_VERSION}"
)

# First, check if exactly the version we want is available
EXACT_VERSION_AVAILABLE=true
for PKG in "${PKGS[@]}"; do
    # Check if the exact version exists
    if ! apt-cache madison "$PKG" | grep -q "$NVIDIA_FULL_VERSION"; then
        EXACT_VERSION_AVAILABLE=false
        echo "[Warning] Exact version $NVIDIA_FULL_VERSION not found for $PKG."
        echo "Available versions for $PKG:"
        apt-cache madison "$PKG" | grep -E "^[[:space:]]+$PKG[[:space:]]+" | awk '{print $3}'
    fi
done

# If exact version not available for all packages, list what's available and exit
if [ "$EXACT_VERSION_AVAILABLE" = false ]; then
    echo "[Error] Exact matching version packages not available for all components."
    echo "Available driver versions in repository:"
    apt-cache madison libnvidia-compute-${NVIDIA_MAJOR_VERSION} | awk '{print $3}' | grep -oE "[0-9]+\.[0-9]+(\.[0-9]+)?"
    echo "Please use one of these available versions or update the repository."
    exit 1
fi

# Build install string with exact versions
INSTALL_ARGS=()
for PKG in "${PKGS[@]}"; do
    # Find the specific version that exactly matches the host version
    VERSION=$(apt-cache madison "$PKG" | grep "$NVIDIA_FULL_VERSION" | awk '{print $3}' | head -n1)
    echo "Will install $PKG=$VERSION"
    INSTALL_ARGS+=("$PKG=$VERSION")
done

# Perform install
apt install -y "${INSTALL_ARGS[@]}"

if [ $? -eq 0 ]; then
    echo "[Success] NVIDIA components installed: ${INSTALL_ARGS[*]}"
    if [ "$UPGRADE_MODE" = true ]; then
        echo "[Success] NVIDIA driver upgrade complete"
    else
        echo "[Success] NVIDIA driver installation complete" 
    fi
else
    echo "[Failure] Driver install failed."
    exit 1
fi