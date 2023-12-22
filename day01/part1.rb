require 'benchmark'

# note: this is just a learning exercise.  ractor doesnt have an advantage on a problem this small.
# however this does demonstrate fan out the work across ractors and then collecting and summing the results.

# plain ruby solution
def part1
  total = 0
  File.open("2023_day_1_input.txt", "r").each do |line|
    first = line.match(/(\d)/)[1].to_i
    last = line.match(/(\d)[^\d]*$/)[1].to_i
    total = total + 10*first + last
  end
  puts total
end

# ractor solution v1. 1 ractor per line, then collect the results.
def part1_ractors_v1
    ractors = []
    File.open("2023_day_1_input.txt", "r").each do |line|
      ractors << Ractor.new(line.freeze) do |line|
        first = line.match(/(\d)/)[1].to_i
        last = line.match(/(\d)[^\d]*$/)[1].to_i
        10*first + last
      end
    end

    total = 0
    until ractors.empty?
      r, value = Ractor.select(*ractors)
      ractors.delete r
      total = total + value
    end
    puts total
end

def parse_line(line)
  first = line.match(/(\d)/)[1].to_i
  last = line.match(/(\d)[^\d]*$/)[1].to_i
  10*first + last
end

# ractor solution v2. 10 worker ractors since an m1 macbook has 10 cores.
def part1_ractors_v2
  pipe = Ractor.new do
    loop do
      Ractor.yield Ractor.receive
    end
  end

  num_workers = 10
  workers = (1..num_workers).map do
    Ractor.new pipe do |pipe|
      while line = pipe.take
        Ractor.yield parse_line(line)
      end
    end
  end

  count = 0
  File.open("2023_day_1_input.txt", "r").each do |line|
    pipe << line.freeze
    count += 1
  end

  total = 0
  (1..count).each do
    _r, b = Ractor.select(*workers)
    total = total + b
  end
  puts total
end

puts "part 1, pain ruby:"
puts Benchmark.measure { part1 }
puts

puts "part 1, ractors v1:"
puts Benchmark.measure { part1_ractors_v1 }
puts

puts "part 1, ractors v2:"
puts Benchmark.measure { part1_ractors_v2 }
