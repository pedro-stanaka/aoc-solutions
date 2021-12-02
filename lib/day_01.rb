# frozen_string_literal: true

# The coolest program
class DayOne
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    File.open(file_name) do |file|
      count_increasing(file.readlines)
    end
  end

  def run_part_two
    File.open(file_name) do |file|
      count_increasing(file.readlines, 3)
    end
  end

  def count_increasing(depth_list, window_size = 1)
    increase_count = 0
    previous = nil
    depth_list.map(&:to_i).each_cons(window_size) do |depth|
      increase_count += 1 if !previous.nil? && previous.sum < depth.sum
      previous = depth
    end

    increase_count
  end
end

