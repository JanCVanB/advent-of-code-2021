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
    |> filterToLocalMinima
    |> convertToRiskLevels
    |> List.sum
    |> Num.toStr
    |> \x -> "Answer 9a:  \(x)"
    |> Stdout.line 

convertToRiskLevels = \heights ->
    List.map heights \h -> h + 1

filterToLocalMinima = \matrix ->
    matrix
    |> List.mapWithIndex (\iy, row ->
        List.mapWithIndex row \ix, z ->
            if isLocalMinimum matrix row z ix iy then
                z
            else
                globalMaximum
    )
    |> List.walk [] \outerValues, row ->
        List.walk row outerValues \innerValues, z ->
            if z == globalMaximum then
                innerValues
            else
                List.append innerValues z

getSafely = \list, index ->
    if index < 0 || index >= List.len list then
        Err ThisIsNotHandledByTheBuiltinListDotGet
    else
        List.get list index

globalMaximum = 9

isLocalMinimum = \matrix, row, z, ix, iy ->
    zNorth = 
        matrix
        |> getSafely (iy - 1)
        |> Result.withDefault []
        |> getSafely ix
        |> Result.withDefault globalMaximum
    zSouth = 
        matrix
        |> getSafely (iy + 1)
        |> Result.withDefault []
        |> getSafely ix
        |> Result.withDefault globalMaximum
    zWest = 
        row
        |> getSafely (ix - 1)
        |> Result.withDefault globalMaximum
    zEast =
        row
        |> getSafely (ix + 1)
        |> Result.withDefault globalMaximum
    z < zNorth && z < zSouth && z < zWest && z < zEast

parse = \stringOfDigitsAndNewlines ->
    stringOfDigitsAndNewlines
    |> Str.split "\n"
    |> List.map \row ->
        row
        |> splitUtf8Characters
        |> List.map \s ->
            s
            |> Str.toNat
            |> Result.withDefault globalMaximum

splitUtf8Characters = \s ->
    s
    |> Str.toUtf8
    |> List.map utf8CharacterToString

utf8CharacterToString = \u ->
    [u]
    |> Str.fromUtf8
    |> Result.withDefault "!"
