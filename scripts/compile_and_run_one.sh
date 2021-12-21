#!/bin/zsh

# Note: This script requires that the Roc CLI is installed
#       and that nix-shell is active with the oc/shell.nix config.

# Example usage: `./scripts/compile_and_run_one.sh ./solutions/day-1-sonar-sweep/solution_1_part_1.roc`

roc $1
