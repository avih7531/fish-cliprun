# Fish shell completions for cliprun

# Complete options
complete -c cliprun -s h -l help -d "Show help message"
complete -c cliprun -s e -l stderr -d "Include stderr in output"
complete -c cliprun -s q -l quiet -d "Silent mode, copy without terminal output"

# Complete files and directories for file arguments
complete -c cliprun -f
