#!/usr/bin/env roc

# Problem 2: https://adventofcode.com/2021/day/2
# Part 1:
#     Calculate the horizontal position and depth you would have after following the planned course.
#     What do you get if you multiply your final horizontal position by your final depth?
# Example:
#      -----------       ------------
#     | forward 5 | --> | x=5,  y=0  | --> 150
#     | down 5    |     | x=5,  y=5  |
#     | forward 8 |     | x=13, y=5  |
#     | up 3      |     | x=13, y=2  |
#     | down 8    |     | x=13, y=10 |
#     | forward 2 |     | x=15, y=10 |
#      -----------       ------------

app "solution_2_part_1"
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
    |> \x -> "Answer 2.1:  \(x)"
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
