function cliprun
    # Detect available clipboard tool
    set -l clipboard_cmd ""
    if command -v wl-copy >/dev/null 2>&1
        set clipboard_cmd wl-copy
    else if command -v xclip >/dev/null 2>&1
        set clipboard_cmd "xclip -selection clipboard"
    else if command -v xsel >/dev/null 2>&1
        set clipboard_cmd "xsel --clipboard --input"
    else
        echo "cliprun: no clipboard tool found" >&2
        echo "Install one of: wl-clipboard (Wayland), xclip (X11), or xsel (X11)" >&2
        return 1
    end

    # Help flag
    if test (count $argv) -eq 1; and contains -- $argv[1] -h --help
        echo "cliprun - Run commands and copy output to clipboard"
        echo ""
        echo "Usage: cliprun [COMMAND | FILE]"
        echo "       COMMAND | cliprun"
        echo ""
        echo "Description:"
        echo "  Executes a command or displays a file, showing output in the terminal"
        echo "  while simultaneously copying stdout to the clipboard."
        echo ""
        echo "Examples:"
        echo "  cliprun ls -la           # Run command and copy output"
        echo "  cliprun config.txt       # Cat file and copy contents"
        echo "  cliprun date             # Copy current date/time"
        echo "  echo hello | cliprun     # Pipe stdin to clipboard"
        echo ""
        echo "Options:"
        echo "  -h, --help    Show this help message"
        return 0
    end

    # Check if stdin is being piped
    if not isatty stdin
        cat | tee /dev/tty | eval $clipboard_cmd
        return
    end

    # No arguments
    if test (count $argv) -eq 0
        echo "cliprun: no command or file specified" >&2
        echo "Try 'cliprun --help' for more information." >&2
        return 1
    end

    # Single argument that is a directory → graceful error
    if test (count $argv) -eq 1; and test -d $argv[1]
        echo "cliprun: '$argv[1]' is a directory" >&2
        return 1
    end

    # Single argument that is a non-executable file → cat
    if test (count $argv) -eq 1; and test -f $argv[1]; and not test -x $argv[1]
        cat $argv[1] 2>/dev/null | tee /dev/tty | eval $clipboard_cmd
        return
    end

    # Otherwise, treat as command
    command $argv 2>/dev/null | tee /dev/tty | eval $clipboard_cmd
end
