# fish-cliprun

A Fish shell plugin that executes commands or displays files while simultaneously copying output to your Wayland clipboard.

## Overview

`cliprun` bridges the gap between terminal output and clipboard operations. Execute any command, view its output in your terminal, and have it automatically copied to your clipboard—all in one seamless operation.

Perfect for developers who frequently copy command output, configuration snippets, or file contents for documentation, sharing, or pasting into other applications.

## Key Features

- **Dual Output**: Displays command output in the terminal while copying to clipboard
- **Smart File Handling**: Automatically cats non-executable text files
- **Clean Output**: Stderr is filtered out by default for cleaner clipboard content
- **Safety First**: Prevents accidental directory operations with graceful error messages
- **Zero Configuration**: Works immediately after installation with sensible defaults

## Requirements

- [Fish shell](https://fishshell.com/) 3.0+
- One of the following clipboard tools:
  - [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (for Wayland) - provides `wl-copy`
  - [xclip](https://github.com/astrand/xclip) (for X11)
  - [xsel](https://github.com/kfish/xsel) (for X11)

### Installing Dependencies

**Arch Linux:**
```bash
# For Wayland
sudo pacman -S wl-clipboard

# For X11
sudo pacman -S xclip
# or
sudo pacman -S xsel
```

**Debian/Ubuntu:**
```bash
# For Wayland
sudo apt install wl-clipboard

# For X11
sudo apt install xclip
# or
sudo apt install xsel
```

**Fedora:**
```bash
# For Wayland
sudo dnf install wl-clipboard

# For X11
sudo dnf install xclip
# or
sudo dnf install xsel
```

## Installation

### Using Fisher

```bash
fisher install avih7531/fish-cliprun
```

### Manual Installation

Clone this repository into your Fish functions directory:

```bash
git clone https://github.com/avih7531/fish-cliprun.git ~/.config/fish/functions/
```

## Usage

### Getting Help

```bash
cliprun --help
# or
cliprun -h
# Displays usage information and examples
```

### Options

**Include stderr (`-e` or `--stderr`):**

By default, stderr is filtered out for cleaner clipboard content. Use this flag to include error output:

```bash
cliprun -e gcc program.c
# Includes compilation errors in the output

cliprun --stderr make test
# Shows test errors and warnings
```

### Basic Command Execution

```bash
cliprun ls -la
# Lists directory contents, displays output, and copies to clipboard

cliprun ip addr
# Shows network interfaces and copies output

cliprun date
# Displays and copies current date/time
```

### File Operations

```bash
cliprun config.yaml
# Displays file contents and copies to clipboard

cliprun ~/.bashrc
# Cats your bashrc and copies it
```

### Piping Input

```bash
echo "hello world" | cliprun
# Pipes stdin to clipboard

curl https://api.github.com/zen | cliprun
# Fetches GitHub zen quote and copies it

cat file.txt | grep error | cliprun
# Filter and copy results
```

### Practical Examples

```bash
# Copy your public SSH key
cliprun cat ~/.ssh/id_rsa.pub

# Copy git log for sharing
cliprun git log --oneline -10

# Copy system information
cliprun uname -a

# Copy the contents of a script
cliprun setup.sh
```

## Behavior Reference

| Input | Action | Clipboard |
|-------|--------|-----------|
| `cliprun --help` | Shows help | Nothing |
| `cliprun` (no args) | Error message | Nothing |
| `echo "x" \| cliprun` | Pipes stdin | Stdin content |
| `cliprun ls -la` | Executes command | Command stdout |
| `cliprun file.txt` | Cats the file | File contents |
| `cliprun ./script.sh` | Executes script | Script output |
| `cliprun directory/` | Error (graceful) | Nothing |

## How It Works

1. **Flag Parsing**: Processes options like `--stderr` before execution
2. **Stdin Detection**: If input is piped, processes it directly
3. **Directory Check**: If given a single directory argument, returns an error
4. **File Detection**: If given a single non-executable file, cats it
5. **Command Execution**: Otherwise, treats arguments as a command to execute
6. **Output Pipeline**: All stdout (and optionally stderr) is piped through `tee` to display locally and to the clipboard tool

## Limitations

- **Clipboard Tool Required**: Needs wl-clipboard (Wayland) or xclip/xsel (X11) installed
- **Stderr Filtered**: Error output is suppressed by default (by design)
- **Single Shot**: Commands execute once; no interactive mode

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Created by [avih7531](https://github.com/avih7531)
