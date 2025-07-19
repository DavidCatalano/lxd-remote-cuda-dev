---
title: Passwordless SSH
---


SSH into static containers without passwords.

---

## Passwordless SSH

Over time, spinning up and tearing down SSH-enabled containers will generate warnings due to host key mismatches in your `known_hosts` file. If you follow this guide, each container in a defined IP range will use its own profile.

#### Potential Warning
```
❯ ssh ubuntu@10.0.0.150
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
```

#### Fix Per Occurrence
```bash
ssh-keygen -R 10.0.0.150
ssh ubuntu@10.0.0.150
```

#### Permanent Fix If You Trust Your LAN
Add this to your `~/.ssh/config`:

```ssh
Host 10.0.0.150 10.0.0.151 10.0.0.152 10.0.0.153 10.0.0.154 10.0.0.155
    User ubuntu
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
```
> This disables fingerprint verification and prevents entries from being stored in `known_hosts`.
> Omit or modify `User ubuntu` if you want to specify the user manually.

Now you can simply connect with:
```bash
ssh 10.0.0.150
```
You'll see the following on first connection:
```
❯ ssh 10.0.0.150
Warning: Permanently added '10.0.0.150' (ED25519) to the list of known hosts.
```
