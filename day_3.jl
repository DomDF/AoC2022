using DelimitedFiles

cd("/Users/ddifrancesco/Github/AoC2022"); rucksacks = readdlm("day_3_data.txt")

function get_priority(item::Char)
    return indexin(item, ['a':'z'; 'A':'Z'])[1]
end

function get_item(rucksack::SubString{String})
    n_items = length(rucksack)
    compartment_1 = rucksack[begin:Int(n_items/2)]
    compartment_2 = rucksack[Int(n_items/2)+1:end]
    return compartment_1[argmax([i ∈ compartment_2 for i ∈ compartment_1])]
end

# Part 1: What is the sum of the priorities of the items in both compartments?

item_priorities = []
for rucksack ∈ rucksacks
    append!(item_priorities, 
            get_item(rucksack) |> x -> get_priority(x))
end

sum(item_priorities)

# Part 2: What is the sum of the priorities of the badges in each 3 elf group?

function get_badge_id(group::Vector{Any})
    item = [(i ∈ group[2]) & (i ∈ group[3]) for i in group[1]] |>
        x -> argmax(x) |>
        x -> group[1][x]
    return item
end

badge_priorities = []
for i ∈ 1:3:length(rucksacks)
    elf_group = rucksacks[i:i+2]
    append!(badge_priorities,
            get_badge_id(elf_group) |> x -> get_priority(x))
end

sum(badge_priorities)