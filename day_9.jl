using DataFrames

cd("/Users/ddifrancesco/Github/AoC2022"); moves = readlines("day_9_data.txt")

move_dict = Dict("U" => [0, 1], "D" => [0, -1], "R" => [1, 0], "L" => [-1, 0])

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

    for i in 1:steps
        chain[begin] = chain[begin] .+ move_dict[dir]
        for l in 1:(len-1)
            chain[l + 1] = move_T(chain[l], chain[l + 1])
            chain[end] ∉ t_prev ? append!(t_prev, [chain[end]]) : []
        end
    end

    return Dict("chain" => [chain], "visited" => [t_prev])
end

# Part 1: How many positions does the tail of the rope visit at least once?

function run_chain(length::Int64, moves::Vector{String}, start::Vector{Int64} = [1, 1])
    chain_init =  repeat([start], length); rope_df = DataFrame(chain = [chain_init], visited = [[start]])
    for move in moves
        action = split(move, " "); dir = action[1]; steps = action[2] |> x -> parse(Int64, x)
        last(rope_df) |>
            x -> move_rope(x.chain, x.visited, dir, steps) |>
            x -> DataFrame(chain = x["chain"], visited = x["visited"]) |>
            x -> append!(rope_df, x)
    end
    return rope_df
end

run_chain(2, moves) |> x -> last(x).visited |> x -> length(x)

# Part 2: How many positions does the tail of the rope (of length, 10) visit at least once?

run_chain(10, moves) |> x -> last(x).visited |> x -> length(x)