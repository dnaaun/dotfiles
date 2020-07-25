#!/bin/sh

set -e

THIS_DIR="$(dirname "$0")"

function main() {
	if [[ -z "$THIS_DIR" ]]; then
		echo "Can't determine the directory which this is getting called from."
		echo "Probably has to do with how this script was invoked."
	else
		do_setup
	fi
}

function do_setup() {
	mkdir -p ~/.config/

}

main
