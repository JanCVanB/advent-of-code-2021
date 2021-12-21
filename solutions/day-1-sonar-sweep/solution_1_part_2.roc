#!/usr/bin/env roc

# Problem 1: https://adventofcode.com/2021/day/1
# Part 2:
#     Consider sums of a three-measurement sliding window.
#     How many sums are larger than the previous sum?
# Example:
#      -----       -----       -------
#     | 199 | --> |     | --> |       | -> 5
#     | 200 |     | 607 |     | start |
#     | 208 |     | 618 |     | up    |
#     | 210 |     | 618 |     | same  |
#     | 200 |     | 617 |     | down  |
#     | 207 |     | 647 |     | up    |
#     | 240 |     | 716 |     | up    |
#     | 269 |     | 769 |     | up    |
#     | 260 |     | 792 |     | up    |
#     | 263 |     |     |     |       |
#      -----       -----       -------

app "solution_1_part_2"
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
    |> \x -> "Answer 1.2:  \(x)"
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
