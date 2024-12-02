
def read_file()
  levels = []
  File.foreach("input.txt") do |line|
    levels << line.split(" ").map(&:to_i)
  end
  levels
end

def part_01(levels)
  safe_reports = 0
  levels.each do |level|
    if safe?(level)
      safe_reports += 1
    end
  end
  safe_reports
end

def part_02(levels)
  safe_reports = 0
  levels.each do |level|
    if safe_by_removing?(level, max_unsafe: 1)
      safe_reports += 1
    end
  end
  safe_reports
end

def safe?(level)
  # puts "-----"
  # puts "checking level: #{level}"
  increasing = true
  decreasing = true
  level.each_with_index do |l, i|
    if i < level.size - 1
      # puts "increasing: #{level[i + 1] - l}"
      # puts "decreasing: #{l - level[i + 1]}"
      increasing = false if level[i + 1] - l > 3 || level[i + 1] - l < 1
      decreasing = false if l - level[i + 1] > 3 || l - level[i + 1] < 1
    end
  end
  safe = increasing || decreasing
  # puts "safe: #{safe}"
  safe
end

def safe_by_removing?(level, max_unsafe: 1)
  return true if safe?(level)

  level.each_with_index do |l, i|
    new_level = level.dup
    new_level.delete_at(i)
    return true if safe?(new_level)
  end

  false
end

levels = read_file()
puts "Part 01: #{part_01(levels)}"
puts "Part 02: #{part_02(levels)}"
