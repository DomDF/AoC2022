using DelimitedFiles

cd("/Users/ddifrancesco/Github/AoC2022"); sections = readdlm("day_4_data.txt")

function get_range(str::SubString{String})
    range = split(str, "-") |>
        x -> [parse(Int, x[i]) for i in 1:length(x)] |>
        x -> x[1]:x[2]
        return range
end

ranges = [get_range(string_range[i]) for i in 1:length(string_range)]

# Part 1: In how many assignment pairs does one range fully contain the other?

function check_fully_contain(ranges::Vector{UnitRange{Int64}})
    if 0 ∉ [section ∈ collect(ranges[2]) for section = collect(ranges[1])] ||
        0 ∉ [section ∈ collect(ranges[1]) for section = collect(ranges[2])]
        return true
    else return false
    end
end

fully_contained_count = []
for section ∈ sections
    ranges = String(section) |> x -> split(x, ",") |>
        x -> [get_range(x[i]) for i in 1:length(x)]
    append!(fully_contained_count, check_fully_contain(ranges))
end

sum(fully_contained_count)

# Part 2: In how many assignment pairs do the ranges overlap?

function check_any_contain(ranges::Vector{UnitRange{Int64}})
    if 1 ∈ [section ∈ collect(ranges[2]) for section = collect(ranges[1])]
        return true
    else return false
    end
end

any_contained_count = []
for section ∈ sections
    ranges = String(section) |> x -> split(x, ",") |>
        x -> [get_range(x[i]) for i in 1:length(x)]
    append!(any_contained_count, check_any_contain(ranges))
end

sum(any_contained_count)