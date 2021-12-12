#!/bin/zsh

# Note: This script requires that roc has already been built.

# Example usage: `./scripts/compile_and_run_one.sh ./solutions/day-1-sonar-sweep/solution_1a.roc`

./roc/target/release/roc $1
