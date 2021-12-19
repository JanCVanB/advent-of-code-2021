#!/bin/zsh

# Note: This script requires that the Roc CLI is installed
#	      and that nix-shell is active with rthe oc/shell.nix config.

# Example usage: `./scripts/compile_and_run_one.sh ./solutions/day-1-sonar-sweep/solution_1a.roc`

roc $1
