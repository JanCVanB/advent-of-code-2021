#!/usr/bin/env roc

app "solution_1b"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ Inputs, pf.Stdout, pf.Task.{ await, Task } ]
    provides [ main ] to pf

main = 
    _ <- await (Stdout.line "")
    Inputs.depthMeasurements
    |> parse
    |> sumTrios
    |> countIncreases
    |> Num.toStr
    |> \x -> "Answer 1b:  \(x)"
    |> Stdout.line

countIncreases = \numbers ->
    aa = List.sublist numbers { start: 0, len: List.len numbers - 1 }
    bb = List.sublist numbers { start: 1, len: List.len numbers - 1 }
    List.map2 aa bb (\a, b -> { a: a, b: b})
    |> List.map (\pair -> if pair.a < pair.b then 1 else 0)
    |> List.sum

parse = \stringOfIntegersAndNewlines ->
    stringOfIntegersAndNewlines
    |> Str.split "\n"
    |> List.keepOks Str.toI64

sumTrios = \numbers ->
    aa = List.sublist numbers { start: 0, len: List.len numbers - 2 }
    bb = List.sublist numbers { start: 1, len: List.len numbers - 2 }
    cc = List.sublist numbers { start: 2, len: List.len numbers - 2 }
    List.map3 aa bb cc (\a, b, c -> [ a, b, c ])
    |> List.map List.sum 
