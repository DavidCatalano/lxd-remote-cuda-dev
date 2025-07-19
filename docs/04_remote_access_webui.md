---
title: Remote Access & Web UI
---

# Remote Access & Web UI

This section explains how to enable remote access to LXD from your LAN and securely expose the built-in Web UI.

## Set Trust Password for Remote Access

```bash
lxc config set core.trust_password "SuperSecretPassword"
```

This password is used when initially adding a remote host. It is not required for day-to-day access after trust is established.

To add Devbox from your Mac:

```bash
lxc remote add devbox 10.0.0.10:8443 --accept-certificate --password=SuperSecretPassword
```

## Enable and Expose the Web UI

Update LXD and configure it to listen on port 8443:

```bash
sudo snap refresh lxd --channel=latest/stable
lxc config set core.https_address :8443
sudo snap set lxd ui.enable=true
sudo systemctl reload snap.lxd.daemon
```

You can now access the Web UI from a browser at:

```
https://10.0.0.10:8443
```

You’ll need to accept the self-signed certificate, or optionally replace it with a trusted cert.

## Certificate Setup (Optional but Recommended)

1. Open the web UI in your browser (e.g. `https://devbox:8443`)
2. Generate and download a `.pfx` certificate from the UI
3. Import it into Keychain Access on macOS
4. Restart your browser
5. In the LXD terminal:

```bash
lxc config trust add --name lxd-ui
```

Paste the key provided from the browser and complete the trust setup.

## Optional: Use a Static IP Bind

Instead of binding to all interfaces, restrict to a specific IP:

```bash
lxc config set core.https_address 10.0.0.10:8443
```

## Production SSL Setup (Optional)

To use your own certificate:

```bash
lxc config set core.https_key /path/to/key.pem
lxc config set core.https_cert /path/to/cert.pem
```

## Check Status

Confirm that LXD remote access is active:

```bash
lxc info
```

Look for output like:

```
- api_status: stable
- https_address: 10.0.0.10:8443
```

