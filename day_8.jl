using DelimitedFiles

cd("/Users/ddifrancesco/Github/AoC2022"); input = readdlm("day_8_data.txt", String)

trees = [parse(Int64, i[j]) for i in input for j ∈ 1:length(input)] |>
    x -> reshape(x, length(input), length(input[1]))

function marginal_scenic_score(Δh, rev::Bool = false)
    if length(Δh) == 0
        ss = 0
    elseif minimum(Δh) > 0
        ss = length(Δh)
    elseif rev == true
        ss = [i <= 0 for i in reverse(Δh)] |> x -> findfirst(x)
    else 
        ss = [i <= 0 for i in Δh] |> x -> findfirst(x)
    end
    return ss
end

function check_visibility(row::Int64, col::Int64, border::Int64 = size(trees)[1])
    height = trees[row, col]; vis = false

    Δh_left = col == 1 ? [] : height .- trees[row, 1:(col-1)]
    Δh_right = col == border ? [] : height .- trees[row, (col+1):end]
    Δh_above = row == 1 ? [] : height .- trees[1:(row-1), col]
    Δh_below = row == border ? [] : height .- trees[(row+1):end, col]

    if row ∈ [1, border] || col ∈ [1, border]
        vis = true  
    elseif (minimum(Δh_above) > 0 || minimum(Δh_below) > 0 || 
            minimum(Δh_left) > 0 || minimum(Δh_right) > 0)
        vis = true
    end
    
    scenic_score = [marginal_scenic_score(Δh_above, true),
                    marginal_scenic_score(Δh_below),
                    marginal_scenic_score(Δh_left, true),
                    marginal_scenic_score(Δh_right)] |>
                        x -> prod(x)

    return [vis, scenic_score]
end

# Part 1: how many trees are visible from outside the grid?

visibility_dict = Dict()
for i ∈ CartesianIndices(trees)
    visibility_dict[i] = check_visibility(i[1], i[2])[1]
end

filter(tree -> tree[2] == 1, visibility_dict) |> d -> length(d)

# Part 2: What is the highest scenic score possible for any tree?

scenic_dict = Dict()
for i ∈ CartesianIndices(trees)
    scenic_dict[i] = check_visibility(i[1], i[2])[2]
end

scenic_dict |>
    x -> values(x) |>
    x -> collect(x) |>
    x -> maximum(x)