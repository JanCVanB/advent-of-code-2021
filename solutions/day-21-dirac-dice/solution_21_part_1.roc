#!/usr/bin/env roc

# Problem 21: https://adventofcode.com/2021/day/21
# Part 1:
#     Play a practice game using the deterministic 100-sided die.
#     The moment either player wins,
#     what do you get if you multiply the score of the losing player
#     by the number of times the die was rolled during the game?
# Example:
#     Player 1 starting position: 4
#     Player 2 starting position: 8
#         1-3: Player 1 rolls 1+2+3 and moves to space 10 for a total score of 10.
#         4-6: Player 2 rolls 4+5+6 and moves to space 3 for a total score of 3.
#         ...
#         988-990: Player 2 rolls 88+89+90 and moves to space 3 for a total score of 745.
#         991-993: Player 1 rolls 91+92+93 and moves to space 10 for a final score, 1000.
#             745 * 993 = 739785

app "solution_21_part_1"
    packages { pf: "../../../clones/roc/examples/cli/platform" }
    imports [ pf.Stdout, pf.Task.{ await, Task }, Inputs ]
    provides [ main ] to pf

maxPosition = 10
maxRoll = 100
maxScore = 1000

main = 
    _ <- await (Stdout.line "")
    Inputs.startingPositions
    |> parse
    |> play
    |> \{ losingScore, rollCount } -> losingScore * rollCount
    |> Num.toStr
    |> \x -> "Answer 21.1: \(x)"
    |> Stdout.line 

initializeState = \setup ->
    { isPlayer1sTurn: True, losingScore: 0, player1Position: setup.player1Position, player1Score: 0, player2Position: setup.player2Position, player2Score: 0, rollCount: 0 }

modulo = \a, b ->
    if a < b then a
    else modulo (a-b) b

move = \state ->
    roll1 = modulo state.rollCount maxRoll + 1
    roll2 = modulo (state.rollCount + 1) maxRoll + 1
    roll3 = modulo (state.rollCount + 2) maxRoll + 1
    rollCount = state.rollCount + 3 
    if state.isPlayer1sTurn then
        player1Position = modulo (state.player1Position + roll1 + roll2 + roll3 - 1) maxPosition + 1
        player1Score = state.player1Score + player1Position
        { state & isPlayer1sTurn: False, player1Position: player1Position, player1Score: player1Score, rollCount: rollCount }
    else
        player2Position = modulo (state.player2Position + roll1 + roll2 + roll3 - 1) maxPosition + 1
        player2Score = state.player2Score + player2Position
        { state & isPlayer1sTurn: True, player2Position: player2Position, player2Score: player2Score, rollCount: rollCount }

moveWhileNobodyWon = \state ->
    if state.player1Score >= maxScore || state.player2Score >= maxScore then
        state
    else
        state
        |> move
        |> moveWhileNobodyWon

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
    |> initializeState
    |> moveWhileNobodyWon
    |> \s -> { s & losingScore: List.min [s.player1Score, s.player2Score] |> Result.withDefault 0 }
