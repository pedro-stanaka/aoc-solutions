# frozen_string_literal: true

# Day Six solution improved!
class DaySeven
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def run
    submarine_positions = File.read(filename).split(',').map(&:to_i)

    Range.new(*submarine_positions.minmax).map do |i|
      submarine_positions.sum { |n| (n - i).abs }
    end.min
  end

  def run_pt2
    submarine_positions = File.read(filename).split(',').map(&:to_i)

    Range.new(*submarine_positions.minmax).map do |i|
      submarine_positions.sum do |n|
        c = (n - i).abs
        (c * (c + 1)) / 2 # Sum of the sequence of 1..n
      end
    end.min
  end
end
