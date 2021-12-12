#!/bin/zsh

# Note: This script requires that roc has already been built.

for solution_module in solutions/**/solution_*.roc; do
	echo "\nCompiling and running $solution_module ..."
	./scripts/compile_and_run_one.sh $solution_module
; done