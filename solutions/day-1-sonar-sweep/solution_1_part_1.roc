#!/usr/bin/env roc

# Problem 1: https://adventofcode.com/2021/day/1
# Part 1:
#     How many measurements are larger than the previous measurement?
# Example:
#      -----       --------
#     | 199 | --> | start  | --> 1+1+1+1+1+1+1 = 7
#     | 200 |     | up (1) |
#     | 208 |     | up (1) |
#     | 210 |     | up (1) |
#     | 200 |     | down   |
#     | 207 |     | up (1) |
#     | 240 |     | up (1) |
#     | 269 |     | up (1) |
#     | 260 |     | down   |
#     | 263 |     | up (1) |
#      -----       --------

app "solution_1_part_1"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ Inputs, pf.Stdout, pf.Task.{ await, Task } ]
    provides [ main ] to pf

main = 
    _ <- await (Stdout.line "")
    Inputs.depthMeasurements
    |> parse
    |> countIncreases
    |> Num.toStr
    |> \x -> "Answer 1.1:  \(x)"
    |> Stdout.line

countIncreases = \numbers ->
    aa = List.sublist numbers { start: 0, len: List.len numbers - 1 }
    bb = List.sublist numbers { start: 1, len: List.len numbers - 1 }
    List.map2 aa bb (\a, b -> { a: a, b: b })
    |> List.map (\pair -> if pair.a < pair.b then 1 else 0)
    |> List.sum

parse = \stringOfIntegersAndNewlines ->
    stringOfIntegersAndNewlines
    |> Str.split "\n"
    |> List.keepOks Str.toI64
