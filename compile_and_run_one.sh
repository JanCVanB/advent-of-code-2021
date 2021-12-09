#!/bin/zsh

# Example usage: `./compile_and_run_one.sh ./solutions/day-1-sonar-sweep/solution_1a.roc`

cd roc
nix-shell --command "cargo run ../$1"
