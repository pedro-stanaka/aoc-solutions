# frozen_string_literal: true

# The coolest program
class DayOne
  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    file = File.open(file_name)

    count_increasing(file.readlines)
  end

  def count_increasing(depth_list)
    increase_count = 0
    previous = nil
    depth_list.map(&:to_i).each do |depth|
      increase_count += 1 if !previous.nil? && previous < depth
      previous = depth
    end

    increase_count
  end
end

