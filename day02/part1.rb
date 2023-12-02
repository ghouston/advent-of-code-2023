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

def valid_draw(draw)
  red, green, blue = draw
  red <= 12 && green <= 13 && blue <= 14
end

def valid_game(draws)
  draws.all? { |draw| valid_draw(draw) }
end

def part_one
  total = 0
  File.open("2023_day_2_input.txt", "r").each do |line|
    id, draws = parse_line(line)
    total += valid_game(draws) ? id : 0
  end
  puts "total: #{total}"
end

puts Benchmark.measure { part_one }