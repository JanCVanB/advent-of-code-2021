#!/usr/bin/env roc

app "solution_1a"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ Inputs, pf.Stdout, pf.Task.{ await, Task } ]
    provides [ main ] to pf

main = 
    _ <- await (Stdout.line "")
    Inputs.depthMeasurements
        |> parse
        |> countIncreases
        |> Num.toStr
        |> \x -> "Answer 1a:  \(x)"
        |> Stdout.line

countIncreases = \numbers ->
    List.mapWithIndex numbers \i, b ->
            when List.get numbers (i-1) is
                Err _ -> 0
                Ok a -> if i >= 1 && a < b then 1 else 0
        |> List.sum

parse = \stringOfIntegersAndNewlines ->
    stringOfIntegersAndNewlines
        |> Str.split "\n"
        |> List.keepOks Str.toI64
