#!/bin/zsh

# Note: This script requires that all solutions have already been compiled.

for solution_module in solutions/**/solution_*.roc; do
	solution_executable="./${solution_module%.*}"
	bash -c $solution_executable
; done
