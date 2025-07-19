---
title: Custom Image Workflows & Lifecycle
---

# Building & Publishing the Image the First Time {#build-publish}
> Note: This assumes there is no image with this name yet

Once a container is configured with all desired packages and settings, you can publish it as a reusable image.

```bash
lxc publish sbox-lg-base-container --alias sbox-lg-latest --alias sbox-lg-v20250502
```

This creates a local image snapshot from the container `sbox-lg-base-container` with two aliases:
- `sbox-lg-latest` (used for launching future containers)
- `sbox-lg-v20250502` (used for version tracking)

Verify with:

```bash
lxc image list
```

# Maintaining Published Image Versions Over Time {#image-versioning}

Maintain historical LXD image versions by tagging snapshots with timestamped aliases.

### Step 1: Remove the existing `sbox-lg-latest` alias
Before publishing a new version, remove the current alias to avoid a conflict:

```bash
lxc image alias delete sbox-lg-latest
```

This ensures you can reuse the alias for the new image.

### Step 2: Publish the updated container with dual aliases
Use the same publish step as before:

```bash
lxc publish sbox-lg-base-container --alias sbox-lg-latest --alias sbox-lg-v20250502
```

This assigns both the current alias and a versioned tag to the new image.

### Step 3: Verify aliases
Check that both aliases are in place:

```bash
lxc image list # note the fingerprint
lxc image alias list <fingerprint>
```

# Using the Image {#using-image}

To launch a new container from the `sbox-lg-latest` image:

```bash
lxc launch sbox-lg-latest my-new-container -p ssh-150 -p gpu1 -p audio -p default-resources
```

Adjust profile stacking as needed (e.g. `gpu-all`, `default` only).

