using DelimitedFiles

cd("/Users/ddifrancesco/Github/AoC2022"); code = readdlm("day_6_data.txt")[1]

function find_marker(code::SubString{String}, chunk_length::Int = 4)
    for l ∈ 1:(length(code) - chunk_length)
        start = l; stop = l + chunk_length - 1; chunk = code[start:stop]
        if unique(chunk) |> x -> length(x) == chunk_length
            return [chunk, stop]; break
        end
    end
end

# Part 1: Where is the first start-of-packet marker?

find_marker(code)

# Part 2: Where is the first start-of-message marker?

find_marker(code, 14)