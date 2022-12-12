using DataFrames

cd("/Users/ddifrancesco/Github/AoC2022"); moves = readlines("day_9_data.txt")

function move_T(H::Vector{Int64}, T::Vector{Int64})
    h = copy(H); t = copy(T); Δt = [0, 0]
    Δx = h[1] - t[1]; Δy = h[2] - t[2]
    if (abs(Δx) >= 1 && abs(Δy) >= 1)
        if Δx > 1 || Δy > 1
            Δt = Δx > 1 ? Δy > 0 ? [1, 1] : [1, -1] : Δx > 0 ? [1, 1] : [-1, 1]
        elseif Δx < -1 || Δy < -1
            Δt = Δx < -1 ? Δy > 0 ? [-1, 1] : [-1, -1] : Δx > 0 ? [1, -1] : [-1, -1]
        end
    elseif Δx > 1 || Δy > 1
        Δt = Δx > 1 ? [1, 0] : [0, 1]
    elseif Δx < -1 || Δy < -1
        Δt = Δx < -1 ? [-1, 0] : [0, -1]
    else
        Δt = [0, 0]
    end
    return t .+ Δt
end

function move_rope(Chain::Vector{Vector{Int64}}, T_prev::Vector{Vector{Int64}}, 
                   dir::SubString{String}, steps::Int64)
    chain = copy(Chain); t_prev = copy(T_prev); len = length(chain)
    if dir == "U"
        for i in 1:steps
            chain[begin] = chain[begin] .+ [0, 1]
            for l in 1:(len-1)
                chain[l + 1] = move_T(chain[l], chain[l + 1])
                chain[end] ∉ t_prev ? append!(t_prev, [chain[end]]) : []
            end
        end
    elseif dir == "D"
        for i in 1:steps
            chain[begin] = chain[begin] .+ [0, -1]
            for l in 1:(len-1)
                chain[l + 1] = move_T(chain[l], chain[l + 1])
                chain[end] ∉ t_prev ? append!(t_prev, [chain[end]]) : []
            end
        end
    elseif dir == "R"
        for i in 1:steps
            chain[begin] = chain[begin] .+ [1, 0]
            for l in 1:(len-1)
                chain[l + 1] = move_T(chain[l], chain[l + 1])
                chain[end] ∉ t_prev ? append!(t_prev, [chain[end]]) : []
            end
        end
    elseif dir == "L"
        for i in 1:steps
            chain[begin] = chain[begin] .+ [-1, 0]
            for l in 1:(len-1)
                chain[l + 1] = move_T(chain[l], chain[l + 1])
                chain[end] ∉ t_prev ? append!(t_prev, [chain[end]]) : []
            end
        end
    end
    return Dict("chain" => [chain], "visited" => [t_prev])
end

# Part 1: How many positions does the tail of the rope visit at least once?

chain_init = repeat([[1, 1]], 2); t_prev_init = [[1, 1]]
rope_df = DataFrame(chain = [chain_init], visited = [t_prev_init])
for move in moves
    action = split(move, " "); dir = action[1]; steps = action[2] |> x -> parse(Int64, x)
    last(rope_df) |>
        x -> move_rope(x.chain, x.visited, dir, steps) |>
        x -> DataFrame(chain = x["chain"], visited = x["visited"]) |>
        x -> append!(rope_df, x)
end

last(rope_df).visited |> x -> length(x)

# Part 2: How many positions does the tail of the rope (of length, 10) visit at least once?

chain_init = repeat([[1, 1]], 10); t_prev_init = [[1, 1]]
rope_df = DataFrame(chain = [chain_init], visited = [t_prev_init])
for move in moves
    action = split(move, " "); dir = action[1]; steps = action[2] |> x -> parse(Int64, x)
    last(rope_df) |>
        x -> move_rope(x.chain, x.visited, dir, steps) |>
        x -> DataFrame(chain = x["chain"], visited = x["visited"]) |>
        x -> append!(rope_df, x)
end

last(rope_df).visited |> x -> length(x)