using DelimitedFiles

cd("/Users/ddifrancesco/Github/AoC2022"); games = readdlm("day_2_data.txt")

# A, X = Rock; B, Y = Paper; C, Z = Scissors
opponent = Dict("A" => "X", "B" => "Y", "C" => "Z")

move_dict = Dict("X" => 1, "Y" => 2, "Z" => 3)
outcome_dict = Dict("Win" => 6, "Draw" => 3, "Lose" => 0)

score_dict = Dict("AX" => move_dict["X"] + outcome_dict["Draw"],
                  "AY" => move_dict["Y"] + outcome_dict["Win"],
                  "AZ" => move_dict["Z"] + outcome_dict["Lose"],
                  "BX" => move_dict["X"] + outcome_dict["Lose"], 
                  "BY" => move_dict["Y"] + outcome_dict["Draw"],
                  "BZ" => move_dict["Z"] + outcome_dict["Win"],
                  "CX" => move_dict["X"] + outcome_dict["Win"], 
                  "CY" => move_dict["Y"] + outcome_dict["Lose"],
                  "CZ" => move_dict["Z"] + outcome_dict["Draw"])

function play_RPS(opponent_move::SubString{String}, my_move::SubString{String})
    if my_move ∉ ["X", "Y", "Z"] || opponent_move ∉ ["A", "B", "C"]
        score = "Please select valid move sets"
    else
        score = score_dict[String(opponent_move)*String(my_move)]
    end
    return score
end

# Part 1: What would your total score be, following this strategy guide?

scores = []
for i in 1:size(games)[1]
    append!(scores, play_RPS(games[i, :][1], games[i, :][2]))
end

sum(scores)

# Part 2: Actually, the XYZ's indicate how the round need to finish.
# "X" => need to lose, "Y" => need to draw, "Z" => need to win

required_result_dict = Dict("X" => "Lose", "Y" => "Draw", "Z" => "Win")

function get_response(opponent_move::SubString{String}, result::SubString{String})
    if required_result_dict[result] == "Draw"
        move = opponent[opponent_move]
    elseif required_result_dict[result] == "Win"
        if opponent_move == "A"
            move = "Y"
        elseif opponent_move == "B"
            move = "Z"
        else move = "X"
        end
    else
        if opponent_move == "A"
            move = "Z"
        elseif opponent_move == "B"
            move = "X"
        else move = "Y"
        end
    end
    return SubString(move)
end

new_scores = []
for i in 1:size(games)[1]
    append!(new_scores, play_RPS(games[i, :][1], 
                                 get_response(games[i, :][1], games[i, :][2])))
end

sum(new_scores)