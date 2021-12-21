#!/usr/bin/env roc

# Problem 2: https://adventofcode.com/2021/day/2
# Part 2:
#     Using this new interpretation of the commands,
#     calculate the horizontal position and depth you would have after following the planned course.
#     What do you get if you multiply your final horizontal position by your final depth?
# Example:
#      -----------       --------------------
#     | forward 5 | --> | x=5,  y=0,  aim=0  | --> 15 * 60 = 900
#     | down 5    |     | x=5,  y=0,  aim=5  |
#     | forward 8 |     | x=13, y=40, aim=5  |
#     | up 3      |     | x=13, y=40, aim=2  |
#     | down 8    |     | x=13, y=40, aim=10 |
#     | forward 2 |     | x=15, y=60, aim=10 |
#      -----------       --------------------

app "solution_2_part_2"
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
    |> \x -> "Answer 2.2:  \(x)"
    |> Stdout.line

follow = \steps ->
    List.walk steps { x: 0, y: 0, aim: 0 } nextPosition

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
        x = position.x + distance
        y = position.y + distance * position.aim 
        { position & x: x, y: y }
    else if direction == "down" then
        { position & aim: position.aim + distance }
    else if direction == "up" then
        { position & aim: position.aim - distance }
    else
        position

parse = \stringOfTextAndNewlines ->
    stringOfTextAndNewlines
    |> Str.split "\n"
