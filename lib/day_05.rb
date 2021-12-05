# frozen_string_literal: true

require 'matrix'
require_relative 'ioutil/file_reader'

# Coordinate for lines
class Coord
  attr_accessor :x_axis, :y_axis

  def initialize(x_axis, y_axis)
    @x_axis = x_axis
    @y_axis = y_axis
  end

  def to_s
    "x: #{x_axis}, y: #{y_axis}"
  end
end

# DayFive solution
class DayFive
  include FileReader

  attr_reader :file_name, :plane

  def initialize(file_name)
    @file_name = file_name
    @plane = Matrix.zero(1000)
  end

  def run(diagonal: false)
    read_file(file_name).map { |l| l.split(' -> ') }.each do |coords|
      start, endl = get_line_coords(coords)

      if lines_are_horizontal(start, endl)
        @plane = put_horizontal_lines_on_plane(start, endl)
      elsif diagonal && lines_are_diagonal(start, endl)
        put_diagonal_lines_on_plane(start, endl)
      end
    end

    cnt = 0
    plane.each { |n| cnt += 1 if n >= 2 }

    cnt
  end

  private

  def get_line_coords(coords)
    c1, c2 = coords

    x1, y1 = c1.split(',')
    start = Coord.new(x1.to_i, y1.to_i)
    x2, y2 = c2.split(',')
    endl = Coord.new(x2.to_i, y2.to_i)

    [start, endl]
  end

  def put_horizontal_lines_on_plane(start, endl)
    minx, maxx = [start.x_axis, endl.x_axis].minmax
    miny, maxy = [start.y_axis, endl.y_axis].minmax

    (minx..maxx).each do |i|
      (miny..maxy).each do |j|
        plane[j, i] += 1
      end
    end

    plane
  end

  def lines_are_horizontal(start, endl)
    start.x_axis == endl.x_axis || start.y_axis == endl.y_axis
  end

  def lines_are_diagonal(start, endl)
    theta = get_line_theta(endl, start)

    (45.0 - theta.abs).abs <= 0.0001
  end

  def get_line_theta(endl, start)
    slope = (endl.y_axis - start.y_axis) / (endl.x_axis - start.x_axis)
    Math.atan(slope) * (180.0 / Math::PI)
  end

  def put_diagonal_lines_on_plane(start, endl)
    minx, maxx = [start.x_axis, endl.x_axis].minmax
    miny, maxy = [start.y_axis, endl.y_axis].minmax

    if get_line_theta(start, endl).positive?
      update_downward_diagonal(Coord.new(minx, miny), maxx)
      return
    end

    # upward diagonal
    (minx..maxx).each do |x|
      plane[maxy, x] += 1
      maxy -= 1
    end
  end

  def update_downward_diagonal(start, max_x)
    min_y = start.y_axis
    (start.x_axis..max_x).each do |x|
      plane[min_y, x] += 1
      min_y += 1
    end
  end

  def print_plane
    plane.row_vectors.to_a.each do |row|
      puts row.to_a.inspect
    end
  end
end
