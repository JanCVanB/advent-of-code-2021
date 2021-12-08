#!/usr/bin/env roc

app "solution_1b"
    packages { base: "../../roc/examples/cli/platform" }
    imports [ base.Stdout, base.Task.{ await, Task }, Inputs ]
    provides [ main ] to base

main : Task {} *
main = 
    {} <- await stateTheProblem
    depthMeasurementTrioSums = sumTrios Inputs.depthMeasurements
    depthIncreaseCount = countIncreases depthMeasurementTrioSums
    present depthIncreaseCount

stateTheProblem = Stdout.line "Problem 1b:"

sumTrios : List Nat -> List Nat
sumTrios = \numbers ->
    length = List.len numbers
    starts = List.sublist numbers {start:0, len:length-2}
    middles = List.sublist numbers {start:1, len:length-2}
    ends = List.sublist numbers {start:2, len:length-2}
    pairs = List.map2 starts middles \start, middle ->
        {start:start, middle:middle}
    trios = List.map2 pairs ends \pair, end ->
        {start:pair.start, middle:pair.middle, end}
    List.map trios \trio ->
        trio.start + trio.middle + trio.end

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
