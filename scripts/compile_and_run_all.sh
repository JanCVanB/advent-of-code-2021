#!/bin/zsh

# Note: This script requires that the Roc CLI is installed
#	      and that nix-shell is active with the roc/shell.nix config.

for solution_module in solutions/**/solution_*.roc; do
	echo "\nCompiling and running $solution_module ..."
	./scripts/compile_and_run_one.sh $solution_module
; done
