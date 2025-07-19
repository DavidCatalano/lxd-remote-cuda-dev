---
title: Developer Environment Setup
---

TODO: Consolidate various environment setup instructions here. Note, some of this is possibly unnecessary.

> NOTE: Bash in as ROOT: `lxc exec s2s-sandbox -- bash` or elevate to ROOT: `sudo su -`

### Node Setup

**1. Install Node.js 22.x (latest) system-wide**
> Run as root user

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs
```

**2. Verify installation**
```bash
node --version  # Should be v22.x.x
npm --version   # Should be v10.x.x
```

**3. Exit root and test with non-root user**
```bash
exit
node --version  # Should be v22.x.x
npm --version   # Should be v10.x.x
```

### Claude Code Setup

**1. Install Claude Code globally**
> Run as root user

```bash
npm install -g @anthropic-ai/claude-code
claude --version # Should be 1.x.xx (Claude Code)
```

**2. Create symlink for non-root user access**
```bash
ln -sf /usr/lib/node_modules/@anthropic-ai/claude-code/cli.js /usr/local/bin/claude
```

**3. Verify install for non-root user**
```bash
exit # exit root user
claude --version # Should be 1.x.xx (Claude Code)
```

> Run `claude init` w/in project folder.

