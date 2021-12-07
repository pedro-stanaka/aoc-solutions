# frozen_string_literal: true

require 'daru'

# Day Six solution improved!
class DaySeven
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def run
    submarine_positions = File.read(filename).split(',').map(&:to_i)
    puts submarine_positions.inspect
  end
end