#!/bin/bash

set -o errexit   # Abort on nonzero exitstatus
set -o nounset   # Abort on unbound variable
set -o pipefail  # Don't hide errors within pipes
set -x           # Print each statement before executing it

# Export Godot game in all platforms
# Requires the version number as an argument
# Example: ./export.sh 1.0.0

version=$1
if [ -z "$version" ]; then
	echo "Please provide the version number as an argument"
	exit 1
fi

# Receives `target` ($1), `folder` ($2), `name` ($3) as arguments
function export_game() {
	echo "target: $1, folder: $2, name: $3"

	# Clean folder contents in case it exists
	if [ -d "$2" ]; then rm -Rf "$2"; fi

	mkdir -p "$2"

	Godot_v4.2.1-stable_linux.x86_64 --export-release "$1" "$2"/"$3"
}

export_game "Linux/X11" "./exports/Linux/$version" "BBBBBB.x86_64"
export_game "Web" "./exports/HTML/$version" "index.html"
export_game "Windows Desktop" "./exports/Windows/$version" "BBBBBB.exe"
