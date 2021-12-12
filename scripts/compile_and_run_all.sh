#!/bin/zsh

for solution_module in solutions/**/solution_*.roc; do
	./scripts/compile_and_run_one.sh $solution_module
; done
