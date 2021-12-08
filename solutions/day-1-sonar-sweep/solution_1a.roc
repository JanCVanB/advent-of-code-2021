#!/usr/bin/env roc

app "solution_1a"
    packages { base: "../../roc/examples/cli/platform" }
    imports [ base.Stdout, base.Task.{ await, Task }, Inputs ]
    provides [ main ] to base

main : Task {} *
main = 
    {} <- await stateTheProblem
    depthIncreaseCount = countIncreases Inputs.depthMeasurements
    present depthIncreaseCount

stateTheProblem = Stdout.line "Problem 1a:"

countIncreases : List Nat -> Nat
countIncreases = \numbers ->
    length = List.len numbers
    befores = List.sublist numbers {start:0, len:length-1}
    afters = List.sublist numbers {start:1, len:length-1}
    pairs = List.map2 befores afters \before, after ->
        {before:before, after:after}
    List.walk pairs 0 \count, pair ->
        if pair.before < pair.after then count + 1 else count

present : Nat -> Task {} *
present = \output ->
    formatted = Num.toStr output
    Stdout.line "    \(formatted)"
