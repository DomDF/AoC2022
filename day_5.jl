cd("/Users/ddifrancesco/Github/AoC2022")

crate_procedure = []
open("day_5_data.txt") do io
    while !eof(io)
        n = readline(io)
        append!(crate_procedure, [n])
    end
end

crate_ids = crate_procedure[9] |> x -> replace(x, " " => "") |>
    x -> [[parse(Int, x[i])] for i ∈ 1:length(x)]

procedure = crate_procedure[11:end]; n_stacks = maximum(crate_ids)[1]

crates = []
for row ∈ 1:n_stacks
    crates_per_row = crate_procedure[begin:9, ][row][2:4:35]
    crates = vcat(crates, crates_per_row)
end

initial_stacks = []
for col ∈ 1:n_stacks
    stack = [c[col] for c ∈ crates] |> x -> [x] |>
        x -> [[x[1][i]] for i ∈ 1:n_stacks if x[1][i] != ' ']
    append!(initial_stacks, [stack])
end

function ints_from_step(proc::Vector{Any}, index::Int)
    ints = [split(proc[j], " ")[index] |> x -> parse(Int, x) for j ∈ 1:length(proc)]
    return ints
end

n_crates = ints_from_step(procedure, 2); from_stacks = ints_from_step(procedure, 4); to_stacks = ints_from_step(procedure, 6)

# Part 1: After the rearrangement procedure completes, what crate ends up on top of each stack?

function rearrange_crates(stacks, num_crates::Int, moving_from::Int, moving_to::Int; one_by_one::Bool = true)
    current_stacks = copy(stacks); moving_stack = []
    for crate ∈ 1:num_crates
        append!(moving_stack, 
                [current_stacks[moving_from][crate]])
    end

    if(one_by_one == true)
        moving_stack = reverse(moving_stack)
    elseif(one_by_one == false)
        moving_stack = moving_stack
    end
        
    current_stacks[moving_to] = [vcat(moving_stack, 
                                      current_stacks[moving_to])[i] for i ∈ 1:length(vcat(moving_stack, current_stacks[moving_to]))]
    current_stacks[moving_from] = current_stacks[moving_from][(num_crates + 1):end]

    return current_stacks
end

new_stacks = copy(initial_stacks)
for task ∈ 1:length(procedure)
    new_stacks = rearrange_crates(new_stacks, n_crates[task], from_stacks[task], to_stacks[task])
end

[new_stacks[i][1] for i ∈ 1:n_stacks]

# Part 2: ...what about if the crates can be picked up together during the re-arranging?

new_stacks = copy(initial_stacks)
for task ∈ 1:length(procedure)
    new_stacks = rearrange_crates(new_stacks, n_crates[task], from_stacks[task], to_stacks[task], 
                                  one_by_one = false)
end

[new_stacks[i][1] for i ∈ 1:n_stacks]