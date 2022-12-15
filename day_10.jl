using DataFrames, DataFramesMeta

cd("/Users/ddifrancesco/Github/AoC2022"); clock = readlines("day_10_data.txt")

clock_seq_df = DataFrame(cycle = 1, register = 1)
for event in clock
    cycle = clock_seq_df |> x -> last(x).cycle; register = clock_seq_df |> x -> last(x).register
    cycle += 1; append!(clock_seq_df, DataFrame(cycle = cycle, register = register))
    if occursin("addx", event)
        cycle += 1; register += split(event, " ")[2] |> x -> parse(Int64, x)
         append!(clock_seq_df, DataFrame(cycle = cycle, register = register))
    end
end

# Part 1: Find the sum of the signal strengths during the 20th, 60th, 100th, 140th, 180th, and 220th cycles

mod_forty_df = clock_seq_df |>
    x -> @rsubset(x, mod(:cycle, 40) == 20) |>
    x -> @rtransform(x, :signal_strength = :cycle * :register)

sum(mod_forty_df.signal_strength)

# Part 2: Render the image given by your program. What eight capital letters appear on your CRT?

CRT_image = clock_seq_df |>
    x -> @rtransform(x, :pixel = mod(:cycle, 40) ∈ [:register, :register+1, :register+2] ? 0 : 1) |>
    x -> reshape(x[begin:end-1, :].pixel, (40, 6)) |>
    x -> transpose(x)

letters = [CRT_image[:, (i-1)*5+1:i*5] for i in 1:8]