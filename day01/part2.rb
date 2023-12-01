require 'benchmark'


NUMS = Hash["one", 1, "two", 2, "three", 3, "four", 4, "five", 5, "six", 6, "seven", 7, "eight", 8, "nine", 9]

def parse_line(line)
  capture = line.match(/(\d|one|two|three|four|five|six|seven|eight|nine)/)[1]
  first = NUMS.fetch(capture, capture.to_i)

  capture = line.reverse.match(/(\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/)[1].reverse
  last = NUMS.fetch(capture, capture.to_i)
  10*first + last
end

def part2
  total = 0
  File.open("2023_day_1_input.txt", "r").each do |line|
    total = total + parse_line(line)
  end
  puts total
end

puts Benchmark.measure { part2 }