#!/bin/zsh

for solution_module in solutions/**/solution_*.roc; do
	./compile_and_run.sh $solution_module
; done
