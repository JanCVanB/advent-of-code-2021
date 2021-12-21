#!/usr/bin/env roc

# Problem 21: https://adventofcode.com/2021/day/21
# Part 2:
#     Using your given starting positions, determine every possible outcome.
#     Find the player that wins in more universes; in how many universes does that player win?
# Example:
#     Player 1 starting position: 4
#     Player 2 starting position: 8
#         1-3: Player 1 rolls ?+?+? (each between 1 and 3) and moves to space ?? (between 7 and 10) for a total score of ?? (between 7 and 10).
#         4-6: Player 2 rolls ?+?+? (each between 1 and 3) and moves to space ?? (between 1 and 7) for a total score of ?? (between 1 and 7).
#         ...
#         ??-??: Player ? rolls ?+?+? (each between 1 and 3) and moves to space ?? for a total score of ??.
#         ??-??: Player ? rolls ?+?+? (each between 1 and 3) and moves to space ?? for a final score, ?? (at least 21).
#             Player 1 wins in 444356092776315 universes.
#             Player 2 wins in 341960390180808 universes.
#                 444356092776315 > 341960390180808 --> 444356092776315

app "solution_21_part_2"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ pf.Stdout, pf.Task.{ await, Task }, Inputs ]
    provides [ main ] to pf

main = 
    _ <- await (Stdout.line "")
    Inputs.startingPositions
    |> parse
    |> play
    # |> (\{ player1WinCount, player2WinCount } ->
    #     List.max [player1WinCount, player2WinCount]
    #     |> Result.withDefault 0)
    # |> Num.toStr
    |> (\{ player1WinCount, player2WinCount } ->
        a = Num.toStr player1WinCount
        b = Num.toStr player2WinCount
        "\(a)|\(b)")
    |> \x -> "Answer 21.2: \(x)"
    |> Stdout.line 

initializeMultiverse = \setup ->
    universe = { isPlayer1sTurn: True, player1Position: setup.player1Position, player1Score: 0, player2Position: setup.player2Position, player2Score: 0 }
    { player1WinCount: 0, player2WinCount: 0, universes: [universe] }

maxPosition = 10

maxScore = 5 # TODO: Increase this to 21

modulo = \a, b ->
    if a < b then a
    else modulo (a-b) b

move = \position, rolls ->
    modulo (position + List.sum rolls - 1) maxPosition + 1

parse = \stringOfSentencesAndNewlines ->
    stringOfSentencesAndNewlines
    |> Str.split "\n"
    |> List.map (\sentence ->
        sentence
        |> Str.split " "
        |> List.last
        |> Result.withDefault "!"
        |> Str.toNat
        |> Result.withDefault 0)
    |> \startingPositions ->
        player1Position = List.first startingPositions |> Result.withDefault 0
        player2Position = List.last startingPositions |> Result.withDefault 0
        { player1Position: player1Position, player2Position: player2Position }

play = \setup ->
    setup
    |> initializeMultiverse
    |> takeTurns

rollPossibilities = [1, 2, 3]

takeTurn = \universe, rolls ->
    if universe.isPlayer1sTurn then
        newPosition = move universe.player1Position rolls 
        newScore = updateScore universe.player1Score newPosition
        { universe & isPlayer1sTurn: False, player1Position: newPosition, player1Score: newScore }
    else
        newPosition = move universe.player2Position rolls
        newScore = updateScore universe.player2Score newPosition
        { universe & isPlayer1sTurn: True, player2Position: newPosition, player2Score: newScore }

takeTurns = \multiverse ->
    if List.len multiverse.universes == 0 then
        multiverse
    else
        List.walk multiverse.universes { multiverse & universes: [] } \newMultiverse, universe ->
            if universe.player1Score >= maxScore then
                { newMultiverse & player1WinCount: newMultiverse.player1WinCount + 1 }
            else if universe.player2Score >= maxScore then
                { newMultiverse & player2WinCount: newMultiverse.player2WinCount + 1 }
            else
                newUniverses =
                    List.walk rollPossibilities [] \a, roll1 ->
                        List.walk rollPossibilities a \b, roll2 ->
                            List.walk rollPossibilities b \c, roll3 ->
                                newUniverse = takeTurn universe [roll1, roll2, roll3]
                                List.append c newUniverse
                takeTurns { newMultiverse & universes: List.concat newMultiverse.universes newUniverses }

updateScore = \score, position -> score + position
