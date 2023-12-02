require 'benchmark'

def parse_line(line)
  id = line.match(/Game\s+(\d+)/)[1].to_i
  draws = line.split(':').last.split(';').map do |draw|
    draw =~ /(\d+) red/ ? red = $1.to_i : red = 0
    draw =~ /(\d+) green/ ? green = $1.to_i : green = 0
    draw =~ /(\d+) blue/ ? blue = $1.to_i : blue = 0
    [red, green, blue]
  end
  [id, draws]
end

def minimum_cubes(mins, draw)
  min_red, min_green, min_blue = mins
  red, green, blue = draw
  mins[0] = [red, min_red].max
  mins[1] = [green, min_green].max
  mins[2] = [blue, min_blue].max
  mins
end

def power_of_minimum_cubes(draws)
  mins = draws.reduce([0,0,0]) { |min_cubes, draw| minimum_cubes(min_cubes, draw) }
  mins[0] * mins[1] * mins[2]
end

def part_two
  total = 0
  File.open("2023_day_2_input.txt", "r").each do |line|
    _id, draws = parse_line(line)
    total += power_of_minimum_cubes(draws)
  end
  puts "total: #{total}"
end

puts Benchmark.measure { part_two }