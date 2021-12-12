#!/bin/zsh

cd roc
nix-shell --command 'cargo build --release'
