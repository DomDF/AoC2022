cd("/Users/ddifrancesco/Github/AoC2022"); terminal = []

open("day_7_data.txt") do io
    while !eof(io)
        n = readline(io)
        append!(terminal, [n])
    end
end

# Thank you to Ryan Chan for assistance!
function find_dir_sizes(input::Vector{Any})
    paths = []; dir_dict = Dict{String,Int64}()
    for line ∈ input
        if startswith(line, "\$ cd ..")
            # move back a directory by removing last path
            pop!(paths)
        elseif startswith(line, "\$ cd ")
            # append the next directory path
            directory = split(line, "\$ cd ")[2]
            if directory == "/"
                push!(paths, "~")
            else
                push!(paths, "$(last(paths))/$(directory)")
            end
        elseif isdigit(line[1])
            # add size of file to all paths
            size = parse(Int64, split(line, " ")[1])
            mergewith!(+, dir_dict, Dict(path => size for path ∈ paths))
        elseif line != "\$ ls" && !startswith(line, "dir")
            throw(error("unexpected line format: $(line)"))
        end
    end
    return dir_dict
end

dir_dict = find_dir_sizes(terminal)

# Part 1: What is the sum of the total sizes of directories smaller than 100000?
max_size = 100000
filter(loc -> loc[2] <= max_size, dir_dict) |> 
    x -> values(x) |> 
    x -> collect(x) |> 
    x -> sum(x) 

# Part 2: What is the total size of the smallest directory that could free up space for the update?
disk_space = 70000000; update_size = 30000000; used_space = dir_dict["~"]
required_space = update_size - (disk_space - used_space)

filter(loc -> loc[2] >= required_space, dir_dict) |>
    d -> filter(loc -> loc[2] == minimum(values(d)), d)