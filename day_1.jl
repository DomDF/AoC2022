using DelimitedFiles

pwd()
cd("/Users/ddifrancesco/Github/AoC2022")

data = readdlm("day_1_data.txt", skipblanks = false, String)

snack_dict = Dict(); elf = 1
for snack in data
    if snack == ""
        elf  += 1
    else
        snack_dict[elf] = get(snack_dict, elf, 0) + parse(Int, snack)
    end
end 

# Part 1: How many calories does the elf carrying the most calories have?

findmax(snack_dict)

# Part 2: ...and what about all of the top 3?

snack_dict |> 
    x -> values(x) |>
    x -> collect(x) |>
    x -> sort(x) |>
    x -> x[end-2 : end] |>
    x -> sum(x)
