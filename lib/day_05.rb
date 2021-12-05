# frozen_string_literal: true

class Coord
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "x: #{x}, y: #{y}"
  end
end

class DayFive
  include FileReader

  attr_reader :file_name, :plane

  def initialize(file_name)
    @file_name = file_name
    @plane = Matrix.zero(1000)
  end

  def put_lines_on_plane(start, endl)
    minx, maxx = [start.x, endl.x].minmax
    miny, maxy = [start.y, endl.y].minmax

    (minx..maxx).each do |i|
      (miny..maxy).each do |j|
        plane[j, i] += 1
      end
    end

    plane
  end

  def lines_are_horizontal(start, endl)
    start.x == endl.x || start.y == endl.y
  end

  def run
    read_file(file_name).map { |l| l.split(' -> ') }.each do |coords|
      c1, c2 = coords
      x1, y1 = c1.split(',')
      start = Coord.new(x1.to_i, y1.to_i)
      x2, y2 = c2.split(',')
      endl = Coord.new(x2.to_i, y2.to_i)

      # puts "start: #{start}" if lines_are_horizontal(start, endl)
      # puts "end: #{endl}" if lines_are_horizontal(start, endl)
      # print_plane if lines_are_horizontal(start, endl)
      # puts '---' if lines_are_horizontal(start, endl)
      @plane = put_lines_on_plane(start, endl) if lines_are_horizontal(start, endl)
    end

    print_plane

    cnt = 0
    plane.each { |n| cnt += 1 if n >= 2 }
    puts "Count: #{cnt}"
  end

  private
  def print_plane()
    plane.row_vectors.to_a.each do |row|
      puts row.to_a.inspect
    end
  end
end
