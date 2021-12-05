# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake/testtask'

Dir.glob('lib/**/*.rb').each { |r| require "#{__dir__}/#{r}" }

task default: %w[lint test]

RuboCop::RakeTask.new(:lint) do |task|
  task.patterns = %w[lib/**/*.rb test/**/*.rb]
  task.fail_on_error = false
end

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :run do
  ruby 'lib/day_01.rb'
end

task :day01 do
  result = DayOne.new("#{__dir__}/inputs/day01.txt").run

  puts "Answer is: #{result}"
end

task :day01_pt2 do
  result = DayOne.new("#{__dir__}/inputs/day01.txt").run_part_two

  puts "Answer is: #{result}"
end

task :day02 do
  coords = DayTwo::Solution.new("#{__dir__}/inputs/day02.txt").run

  puts "Result is #{coords[:depth] * coords[:horizon]}"
end

task :day02_pt2 do
  coords = DayTwo::Solution.new("#{__dir__}/inputs/day02.txt").run_part_two

  puts "Result is #{coords[:depth] * coords[:horizon]}"
end

task :day03 do
  rates = DayThree.new("#{__dir__}/inputs/day03.txt").run

  puts "Result is #{rates[:gamma] * rates[:epsilon]}"
end

task :day03_pt2 do
  rates = DayThree.new("#{__dir__}/inputs/day03.txt").run_pt2

  puts "Result is #{rates[:oxygen] * rates[:co2]}"
end

task :day05 do
  intersection_count = DayFive.new("#{__dir__}/inputs/day05.txt").run

  puts "Number of intersections with two or more lines: #{intersection_count}"
end

task :day05_pt2 do
  intersection_count = DayFive.new("#{__dir__}/inputs/day05.txt").run(diagonal: true)

  puts "Number of intersections with two or more lines: #{intersection_count}"
end
