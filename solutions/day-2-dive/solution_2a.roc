#!/usr/bin/env roc

app "solution_2a"
    packages { base: "../../roc/examples/cli/platform" }
    imports [ base.Stdout, base.Task.{ await, Task }, Inputs ]
    provides [ main ] to base

main : Task {} *
main = 
    _ <- await stateTheProblem
    position = follow Inputs.course
    xyProduct = multiplyXByY position
    present xyProduct

stateTheProblem = Stdout.line "Problem 2a:"

follow : List Str -> { x: Nat, y: Nat }
follow = \course ->
    if List.len course == 0 then
        { x: 0, y: 0 }
    else 
        step =
            when List.first course is
                Ok s -> Str.split s " "
                Err _ -> ["forward", "0"]
        direction =
            when List.first step is
                Ok s -> s
                Err _ -> "forward"
        distance =
            when List.last step is
                Ok s ->
                    if s == "1" then
                        1
                    else if s == "2" then
                        2
                    else if s == "3" then
                        3
                    else if s == "4" then
                        4
                    else if s == "5" then
                        5
                    else if s == "6" then
                        6
                    else if s == "7" then
                        7
                    else if s == "8" then
                        8
                    else if s == "9" then
                        9
                    else
                        0
                Err _ -> 0
        future = follow (List.sublist course { start: 1, len: List.len course - 1 })
        if direction == "forward" then
            { x: future.x + distance, y: future.y }
        else if direction == "down" then
            { x: future.x, y: future.y + distance }
        else if direction == "up" then
            { x: future.x, y: future.y - distance }
        else
            { x: future.x, y: future.y }

multiplyXByY : { x: Nat, y: Nat } -> Nat
multiplyXByY = \position -> position.x * position.y

present : Nat -> Task {} *
present = \output ->
    formatted = Num.toStr output
    Stdout.line "    \(formatted)"
