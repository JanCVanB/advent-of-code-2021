#!/usr/bin/env roc

app "solution_9a"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ pf.Stdout, pf.Task.{ await, Task }, Inputs ]
    provides [ main ] to pf

main : Task {} *
main = 
    _ <- await (Stdout.line "")
    Inputs.heightMap
    |> parse
    |> computeBasinHeights
    |> computeRiskLevels
    |> List.sum
    |> Num.toStr
    |> \x -> "Answer 9a:  \(x)"
    |> Stdout.line 

computeBasinHeights = \heightMatrix ->
    heightMatrix
        |> List.mapWithIndex (\y, row ->
            List.mapWithIndex row (\x, h -> if isBasin heightMatrix x y then h else 9))
        |> List.walk [] \a, row ->
            List.walk row a \b, height ->
                if height == 9 then b else List.append b height

computeRiskLevels = \basinHeights ->
    List.map basinHeights \h -> h + 1

getWithDefault = \list, index, default ->
    List.get list index |> Result.withDefault default

isBasin = \matrix, x, y ->
    north = 
        if y <= 0 then 9
        else matrix
            |> getWithDefault (y - 1) []
            |> getWithDefault x 9
    south = 
        if y >= (List.len matrix) - 1 then 9
        else matrix
            |> getWithDefault (y + 1) []
            |> getWithDefault x 9
    row = List.get matrix y |> Result.withDefault []
    west =
        if x <= 0 then 9
        else getWithDefault row (x - 1) 9
    east = 
        if x >= (List.len row) - 1 then 9
        else getWithDefault row (x + 1) 9
    h = List.get row x |> Result.withDefault 9
    h < north && h < south && h < west && h < east

parse = \stringOfDigitsAndNewlines ->
    stringOfDigitsAndNewlines
    |> Str.split "\n"
    |> List.map \row ->
        row
        |> splitUtf8Characters
        |> List.map \c ->
            when Str.toNat c is
                Ok n -> n
                Err _ -> 9

splitUtf8Characters = \s ->
    s
    |> Str.toUtf8
    |> List.map utf8CharacterToString

utf8CharacterToString = \u ->
    when Str.fromUtf8 [u] is
        Err _ -> "!"
        Ok c -> c
