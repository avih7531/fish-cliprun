# fish-cliprun

A small Fish shell plugin that runs a command or cats a file, prints output normally, and copies stdout to the Wayland clipboard.

`cliprun` runs a command once, mirrors stdout to the terminal, and copies it to the clipboard.

## Features

- Runs commands once (no re-execution)
- Copies stdout to clipboard using wl-copy
- Displays output normally in the terminal
- Silences stderr by default
- Gracefully errors on directories
- Cats non-executable files automatically

## Requirements

- Fish shell
- wl-clipboard (wl-copy)

## Installation (fisher)

`fisher install yourname/fish-cliprun`

## Usage

`cliprun ls -la`
`cliprun ip addr`
`cliprun notes.txt`

## Behavior

Input: `cliprun ls -la`
Result: run command

Input: `cliprun file.txt`
Result: cat file

Input: `cliprun dir/`
Result: error

Input: `cliprun ./script.sh`
Result: execute

