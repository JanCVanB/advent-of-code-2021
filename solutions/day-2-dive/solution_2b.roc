#!/usr/bin/env roc

app "solution_2b"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ Inputs, pf.Stdout, pf.Task.{ await, Task } ]
    provides [ main ] to pf

main = 
    _ <- await (Stdout.line "")
    Inputs.steps
        |> parse
        |> follow
        |> \position -> position.x * position.y
        |> Num.toStr
        |> \x -> "Answer 2b:  \(x)"
        |> Stdout.line

follow = \steps ->
    List.walk steps { x: 0, y: 0, aim: 0 } \position, step ->
        substeps = Str.split step " "
        direction = List.first substeps
            |> Result.withDefault ""
        distance = List.last substeps
            |> Result.withDefault ""
            |> Str.toI64
            |> Result.withDefault 0
        if direction == "forward" then
            { x: position.x + distance, y: position.y + distance * position.aim, aim: position.aim }
        else if direction == "down" then
            { x: position.x, y: position.y, aim: position.aim + distance }
        else if direction == "up" then
            { x: position.x, y: position.y, aim: position.aim - distance }
        else
            { x: position.x, y: position.y, aim: position.aim }

parse = \stringOfTextAndNewlines ->
    stringOfTextAndNewlines
        |> Str.split "\n"
