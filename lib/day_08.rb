# frozen_string_literal: true

require_relative 'ioutil/file_reader'

# Day Six solution improved!
class DayEight
  attr_reader :filename

  include FileReader

  SIZES_1478 = [2, 4, 3, 7].freeze

  def initialize(filename)
    @filename = filename
  end

  def run
    notes = []
    outputs = []
    read_file(filename).map do |line|
      note, output = line.split('|')

      output = output.split(' ').map { |o| o.scan(/\w/).sort.join }
      note = note.split(' ').map { |o| o.scan(/\w/).sort.join }

      notes += note
      outputs += output
    end

    outputs.filter { |o| SIZES_1478.include? o.size }.count
  end
end
