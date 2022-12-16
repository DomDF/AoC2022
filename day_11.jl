cd("/Users/ddifrancesco/Github/AoC2022"); input = readlines("day_11_data.txt")

monkey_indices = []
for (index, line) in enumerate(input)
    if startswith(line, "Monkey")
        append!(monkey_indices, index)
    end
end

mutable struct 🐒
    items::Vector{BigInt}
    worry_op::SubString{String}
    check_division::Int64
    outcome_true::Int64
    outcome_false::Int64
    n_inspections::Int64
end

monkey_dict = Dict()
for i ∈ monkey_indices
    id = split(input[i], " ")[2] |> x -> split(x, ":")[1] |> x -> parse(Int64, x) |> x -> x+1
    🐒(split(input[i+1], ":")[2] |> x -> split(x, ",") |> x -> parse.(Int64, x),
       split(input[i+2], "= old ")[2],
       split(input[i+3], "by ")[2] |> x -> parse(Int64, x),
       split(input[i+4], "monkey ")[2] |> x -> parse(Int64, x) |> x -> x+1,
       split(input[i+5], "monkey ")[2] |> x -> parse(Int64, x) |> x -> x+1, 
       0) |>
        x -> mergewith!(+, monkey_dict, Dict(id => x))
end
[monkey_dict[m].worry_op = monkey_dict[m].worry_op == "* old" ? "^ 2" : monkey_dict[m].worry_op for m ∈ 1:length(monkey_dict)]

prime_dividers = [monkey_dict[i].check_division for i in 1:length(monkey_dict)]

function update_monkeys(monkeys::Dict{Any, Any}, n_rounds::Int64, auto_calming::Bool = true, calming::Int64 = 3)
    for _ ∈ 1:n_rounds
        for m ∈ 1:length(monkeys)
            🐵 = monkeys[m]; 🐵.n_inspections += length(🐵.items)
            if length(🐵.items) > 0
                op = split(🐵.worry_op, " ")
                if op[1] == "*"
                    🐵.items = 🐵.items .* parse(Int64, op[2])
                elseif op[1] == "+"
                    🐵.items = 🐵.items .+ parse(Int64, op[2])
                else
                    🐵.items = 🐵.items .^2
                end
                if auto_calming
                    🐵.items = 🐵.items .÷ calming |> x -> floor.(x)
                else
                    🐵.items = mod.(🐵.items, prod(prime_dividers))
                end
                append!(monkeys[🐵.outcome_true].items, 🐵.items[mod.(🐵.items, 🐵.check_division) .== 0]) 
                append!(monkeys[🐵.outcome_false].items, 🐵.items[mod.(🐵.items, 🐵.check_division) .!= 0])
                🐵.items = Vector{BigInt}[]
            end
        end
    end
    return monkeys
end

# Part 2: What is the level of monkey business after 20 rounds of shenanigans?

final_monkeys_pt1 = update_monkeys(monkey_dict, 20)

function monkey_business(monkeys::Dict{Any, Any}, n_active::Int64 = 2)
    active_monkeys = monkeys |>
        x -> [x[m].n_inspections for m ∈ 1:length(x)] |>
        x -> partialsortperm(x, 1:n_active, rev = true) |>
        x -> [monkeys[x[i]] for i in 1:length(x)]
    return [active_monkeys[i].n_inspections for i in 1:n_active] |> x -> prod(x)
end

monkey_business(final_monkeys_pt1)

# Part 2: What is the level of monkey business after 10,000 rounds (with no calming)?

update_monkeys(monkey_dict, 10^4, false) |>
    x -> monkey_business(x)