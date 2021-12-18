#!/usr/bin/env roc

app "solution_1b"
    packages { pf: "../../roc/examples/cli/platform" }
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
    List.mapWithIndex numbers \i, b ->
            when List.get numbers (i-1) is
                Err _ -> 0
                Ok a -> if i >= 1 && a < b then 1 else 0
        |> List.sum

parse = \stringOfIntegersAndNewlines ->
    stringOfIntegersAndNewlines
        |> Str.split "\n"
        |> List.keepOks Str.toI64

sumTrios = \numbers ->
    List.mapWithIndex numbers \i, c ->
            when List.get numbers (i-2) is
                Err _ -> Err DropMe
                Ok a -> 
                    when List.get numbers (i-1) is
                        Err _ -> Err DropMe
                        Ok b -> if i >= 2 then Ok (a + b + c) else Err DropMe
        |> List.keepOks \x -> x
