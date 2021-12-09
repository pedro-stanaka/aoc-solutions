# frozen_string_literal: true

require_relative 'ioutil/file_reader'
require 'matrix'

# Day Six solution improved!
class DayNine
  attr_reader :filename, :floor_map

  include FileReader

  def initialize(filename)
    @filename = filename
    inp = read_file(filename).map { |l| l.scan(/\w/).map(&:to_i) }
    @floor_map = Matrix.rows(inp, false)
  end

  def run
    low_points = []
    (0..floor_map.row_size - 1).each do |r|
      (0..floor_map.column_size - 1).each do |c|
        low_points.push(floor_map[r, c]) if low_point?(r, c)
      end
    end

    low_points.map { |p| p + 1 }.sum
  end

  def run_pt2; end

  private

  def build_adjacency_for(row, col)
    adjacency_list = []

    # top - have to take care of negative index which will work on ruby,
    # but have negative side effect
    top_r = (row - 1).negative? ? nil : row - 1
    adjacency_list.push(floor_map[top_r, col]) unless top_r.nil?

    # left
    left_c = (col - 1).negative? ? nil : col - 1
    adjacency_list.push(floor_map[row, left_c]) unless left_c.nil?

    # bottom - relying on old good nil, which we filter later.
    adjacency_list.push(floor_map[row + 1, col])

    # right - same, rely on nil
    adjacency_list.push(floor_map[row, col + 1])

    adjacency_list.reject(&:nil?)
  end

  def low_point?(row, col)
    adjacency_list = build_adjacency_for(row, col)
    minimum_neighbor = adjacency_list.min

    floor_map[row, col] < minimum_neighbor
  end
end
