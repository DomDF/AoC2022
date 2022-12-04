using DelimitedFiles

cd("/Users/ddifrancesco/Github/AoC2022")
data = readdlm("day_1_data.txt", skipblanks = false, String)

snack_dict = Dict(); elf = 1
for snack ∈ data
    if snack == ""
        elf  += 1
    else
        snack_dict[elf] = get(snack_dict, elf, 0) + parse(Int, snack)
    end
end 

# Part 1: How many calories does the elf carrying the most calories have?

findmax(snack_dict)

# Part 2: ...and what about all of the top 3?

function top_n_calories(snack_dict::Dict, n_elves::Int)
    top_n_calories = values(snack_dict) |>
        x -> collect(x) |>
        x -> sort(x, rev = true) |>
        x -> x[1:n_elves]
    return top_n_calories
end

top_n_calories(snack_dict, 3) |> x -> sum(x)