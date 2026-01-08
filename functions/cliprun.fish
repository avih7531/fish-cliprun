function cliprun
    # Parse options
    set -l show_stderr 0
    set -l quiet_mode 0
    set -l new_argv
    
    for arg in $argv
        switch $arg
            case -h --help
                echo "cliprun - Run commands and copy output to clipboard"
                echo ""
                echo "Usage: cliprun [OPTIONS] [COMMAND | FILE]"
                echo "       COMMAND | cliprun [OPTIONS]"
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
                echo "  cliprun -e gcc prog.c    # Include stderr in output"
                echo "  cliprun -q date          # Copy silently without terminal output"
                echo ""
                echo "Options:"
                echo "  -e, --stderr  Include stderr in output (default: filtered)"
                echo "  -q, --quiet   Silent mode, copy without terminal output"
                echo "  -h, --help    Show this help message"
                return 0
            case -e --stderr
                set show_stderr 1
            case -q --quiet
                set quiet_mode 1
            case '*'
                set -a new_argv $arg
        end
    end
    
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

    # Check if stdin is being piped
    if not isatty stdin
        if test $quiet_mode -eq 1
            cat | eval $clipboard_cmd
        else
            cat | tee /dev/tty | eval $clipboard_cmd
        end
        return
    end

    # No arguments
    if test (count $new_argv) -eq 0
        echo "cliprun: no command or file specified" >&2
        echo "Try 'cliprun --help' for more information." >&2
        return 1
    end

    # Set stderr redirection based on flag
    set -l stderr_redirect "2>/dev/null"
    if test $show_stderr -eq 1
        set stderr_redirect "2>&1"
    end

    # Single argument that is a directory → graceful error
    if test (count $new_argv) -eq 1; and test -d $new_argv[1]
        echo "cliprun: '$new_argv[1]' is a directory" >&2
        return 1
    end

    # Set display command based on quiet mode
    set -l display_cmd "tee /dev/tty"
    if test $quiet_mode -eq 1
        set display_cmd "cat"
    end

    # Single argument that is a non-executable file → cat
    if test (count $new_argv) -eq 1; and test -f $new_argv[1]; and not test -x $new_argv[1]
        eval "cat $new_argv[1] $stderr_redirect | $display_cmd | $clipboard_cmd"
        return
    end

    # Otherwise, treat as command
    eval "command $new_argv $stderr_redirect | $display_cmd | $clipboard_cmd"
end
