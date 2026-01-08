function cliprun
    # Help flag
    if test (count $argv) -eq 1; and contains -- $argv[1] -h --help
        echo "cliprun - Run commands and copy output to clipboard"
        echo ""
        echo "Usage: cliprun [COMMAND | FILE]"
        echo ""
        echo "Description:"
        echo "  Executes a command or displays a file, showing output in the terminal"
        echo "  while simultaneously copying stdout to the Wayland clipboard."
        echo ""
        echo "Examples:"
        echo "  cliprun ls -la           # Run command and copy output"
        echo "  cliprun config.txt       # Cat file and copy contents"
        echo "  cliprun date             # Copy current date/time"
        echo ""
        echo "Options:"
        echo "  -h, --help    Show this help message"
        return 0
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
        cat $argv[1] 2>/dev/null | tee /dev/tty | wl-copy
        return
    end

    # Otherwise, treat as command
    command $argv 2>/dev/null | tee /dev/tty | wl-copy
end
