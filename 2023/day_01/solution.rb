
WORD_TO_DIGIT = {
  "one" => "1",
  "two" => "2",
  "three" => "3",
  "four" => "4",
  "five" => "5",
  "six" => "6",
  "seven" => "7",
  "eight" => "8",
  "nine" => "9"
}.freeze

def extract_calibration_value(line, regex)
  matches = line.scan(regex)

  [matches.first, matches.last]
end
def get_calibration_value(line)
  matches = extract_calibration_value(line, /\d/)
  matches.join.to_i
end

def get_calibration_value_spelled_digits(line)
  digits_regex = /one|two|three|four|five|six|seven|eight|nine|\d/

  matches = extract_calibration_value(line, digits_regex)
  res = matches.map do |m|
    next WORD_TO_DIGIT[m] if WORD_TO_DIGIT.key?(m)
    m
  end.join

  res.to_i
end

# input = File.read("part01_input.txt").split("\n")
#
# sum = input.map do |line|
#   get_calibration_value(line)
# end.sum
#
# puts "sum: #{sum}"


input_part_2 = File.read("part02_input.txt").split("\n")
values = input_part_2.map do |l|
  value = get_calibration_value_spelled_digits(l)
  puts "value for line #{l}: #{value}"
  puts "matches for line #{l}: #{extract_calibration_value(l,/one|two|three|four|five|six|seven|eight|nine|\d/)}"
  puts "--------"
  value
end

sum = values.sum

puts "Sum of part 2: #{sum}"
