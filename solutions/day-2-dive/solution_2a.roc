#!/usr/bin/env roc

app "solution_2a"
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
    |> \x -> "Answer 2a:  \(x)"
    |> Stdout.line

follow = \steps ->
    List.walk steps { x: 0, y: 0 } nextPosition

getDirection = \step ->
    step
    |> Str.split " "
    |> List.first
    |> Result.withDefault ""

getDistance = \step ->
    step
    |> Str.split " "
    |> List.last
    |> Result.withDefault ""
    |> Str.toI64
    |> Result.withDefault 0

nextPosition = \position, step ->
    direction = getDirection step
    distance = getDistance step
    if direction == "forward" then
        { position & x: position.x + distance }
    else if direction == "down" then
        { position & y: position.y + distance }
    else if direction == "up" then
        { position & y: position.y - distance }
    else
        position

parse = \stringOfTextAndNewlines ->
    stringOfTextAndNewlines
    |> Str.split "\n"
