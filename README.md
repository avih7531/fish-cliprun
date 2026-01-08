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
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (provides `wl-copy` for Wayland)

### Installing Dependencies

**Arch Linux:**
```bash
sudo pacman -S wl-clipboard
```

**Debian/Ubuntu:**
```bash
sudo apt install wl-clipboard
```

**Fedora:**
```bash
sudo dnf install wl-clipboard
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
| `cliprun ls -la` | Executes command | Command stdout |
| `cliprun file.txt` | Cats the file | File contents |
| `cliprun ./script.sh` | Executes script | Script output |
| `cliprun directory/` | Error (graceful) | Nothing |

## How It Works

1. **Directory Check**: If given a single directory argument, returns an error
2. **File Detection**: If given a single non-executable file, cats it
3. **Command Execution**: Otherwise, treats arguments as a command to execute
4. **Output Pipeline**: All stdout is piped through `tee` to display locally and `wl-copy` for clipboard

## Limitations

- **Wayland Only**: Requires Wayland display server and `wl-copy`
- **Stderr Filtered**: Error output is suppressed by default (by design)
- **Single Shot**: Commands execute once; no interactive mode

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests on GitHub.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Author

Created by [avih7531](https://github.com/avih7531)
