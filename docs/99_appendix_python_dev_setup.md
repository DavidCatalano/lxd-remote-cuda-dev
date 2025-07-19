---
title: Python Development in LXD (plus VS Code Remote SSH)
---

## Python Development Setup in LXD Container

This guide outlines how to set up a Python development environment inside an LXD container using `uv`, with full support for VS Code Remote SSH.

---

## 1. Create Your Project Folder

Inside the container as the `ubuntu` user:

```bash
mkdir ~/app
cd ~/app
```

You may choose a different name (e.g., `sandbox`, `workspace`) depending on your project.

---

## 2. Create a Virtual Environment with Python 3.13

`uv` automatically downloads and manages Python versions. To create a virtual environment using Python 3.13:

```bash
uv venv --python 3.13
source .venv/bin/activate
```

This ensures your environment uses Python 3.13 without modifying the system Python.

> For the latest version run `uv venv` without the --python flag

---

## 3. Set Up VS Code Integration

Create a `.vscode` directory in your project:

```bash
mkdir .vscode
```

### `.vscode/settings.json`

```json
{
    "editor.formatOnSave": true,
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "[python]": {
        "editor.defaultFormatter": "ms-python.black-formatter",
        "editor.formatOnSave": true,
        "editor.codeActionsOnSave": {
            "source.organizeImports.ruff": "explicit"
        }
    },
    "python.analysis.typeCheckingMode": "strict"
}
```

### `.vscode/extensions.json`

```json
{
    "recommendations": [
        "ms-python.python",
        "redhat.vscode-yaml",
        "ms-python.black-formatter",
        "charliermarsh.ruff",
        "ms-python.mypy-type-checker"
    ]
}
```

---

## 4. Initialize a Python Project

From the root of your project folder (e.g. `~/app`), run:

```bash
uv init --app
```

This will create a scaffold including `pyproject.toml`, `.venv`, `.gitignore`, and more.

### Project Types Available via `uv init`

| Flag           | Description                                            |
| -------------- | ------------------------------------------------------ |
| `--lib`        | Create a reusable library (Python package)             |
| `--app`        | Create an application (scriptable or runnable project) |
| `--script`     | Create a minimal script-style project                  |
| `--package`    | Same as `--lib`, sets up for distribution              |
| `--no-package` | Avoid packaging setup                                  |

---

## 5. Customize `pyproject.toml`

Once the scaffold is created, append the following to the bottom of `pyproject.toml` to add your dev tooling preferences:

```toml
[project.optional-dependencies]
dev = ["ruff", "black", "mypy"]

[tool.black]
line-length = 88
target-version = ["py310"]
skip-string-normalization = false

[tool.ruff]
line-length = 88
target-version = "py310"
extend-select = ["I"]
fix = true

[tool.mypy]
python_version = "3.10"
strict = true
ignore_missing_imports = true
```

---

## 6. Connect VS Code to the Project

Use the **Remote SSH** extension in VS Code to connect to your container.

Once connected, open the `~/app` folder.

VS Code should:

- Prompt you to install the recommended extensions.
- Detect the `.venv` created by `uv init`.
- Use Python 3.13 (via `.venv`) as the interpreter automatically.

If it doesn’t, press `Ctrl+Shift+P` or `Cmd+Shift+P` and run:

> **Python: Select Interpreter** → choose the one from `.venv/bin/python`

You're now ready to develop in a modern, versioned Python environment fully integrated with VS Code.

---

## Switching Python Versions

### Quick Test (--python flag)

```bash
uv venv --python 3.11.6
```

> Note: This will not adjust .python-version which may cause issues with tools that reference it.

### Recommended (.python-version / uv sync)

Edit the `.python-version` file to contain just the desired Python version number:

```
3.11.6
```

Then run:

```bash
uv sync
```

This will recreate the environment using the specified version.

### Maintain reasonable pyproject.toml version

In your `pyproject.toml` file, update the value:

```toml
requires-python = ">=3.11"
```

This ensures compatibility metadata reflects the active Python version.
