# frozen_string_literal: true

require_relative 'ioutil/file_reader'
require 'matrix'
require 'set'

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
    low_points.map { |(r, c)| floor_map[r, c] + 1 }.sum
  end

  def run_pt2
    basin_sizes = low_points.map do |(y, x)|
      basin = create_basin(y, x)
      basin.size
    end

    top_three_basins = basin_sizes.sort.reverse[0..2]

    top_three_basins.reduce(&:*)
  end

  private

  def low_points
    low_points = []
    (0..floor_map.row_size - 1).each do |r|
      (0..floor_map.column_size - 1).each do |c|
        low_points.push([r, c]) if low_point?(r, c)
      end
    end
    low_points
  end

  def create_basin(row, col, basin = Set[])
    basin.add([row, col])

    [[row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]].each do |(yd, xd)|
      basin.merge(create_basin(yd, xd, basin)) if highest_point(yd, xd) && !basin.include?([yd, xd])
    end

    basin
  end

  def highest_point(row, col)
    return false if row.negative? || col.negative?

    floor_map[row, col].nil? ? false : floor_map[row, col] < 9
  end

  def build_adjacency_for(row, col)
    adjacency_list = []

    # top - have to take care of negative index which will work on ruby,
    # but have negative side effect
    adjacency_list.push(floor_map[row - 1, col]) unless (row - 1).negative?

    # left
    adjacency_list.push(floor_map[row, col - 1]) unless (col - 1).negative?

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
