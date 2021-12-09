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
    outputs = detected_numbers
    outputs.sum { |p| p.count(&:first) }
  end

  def run_pt2
    outputs = detected_numbers
    outputs.sum { |p| p.map(&:last).join.to_i }
  end

  private

  def detected_numbers
    read_file(filename).map do |line|
      note, output = line.split('|')


      by_length = note.split(' ').each_with_object(Hash.new { |h, k| h[k] = [] }) do |connection, h|
        h[connection.length] << connection.chars.sort
      end

      segments_for = {}
      segments_for[1] = by_length[2].shift
      segments_for[4] = by_length[4].shift
      segments_for[7] = by_length[3].shift
      segments_for[8] = by_length[7].shift
      segments_for[3] = detect_and_delete(by_length[5]) { |c| (segments_for[1] - c).empty? }
      segments_for[9] = detect_and_delete(by_length[6]) { |c| (segments_for[4] - c).empty? }
      segments_for[5] = detect_and_delete(by_length[5]) { |c| (c - segments_for[9]).empty? }
      segments_for[2] = by_length[5].shift
      segments_for[6] = detect_and_delete(by_length[6]) { |c| (segments_for[5] - c).empty? }
      segments_for[0] = by_length[6].shift

      number_for = segments_for.invert

      output.split(' ').map do |o|
        number = number_for[o.chars.sort]

        [[1, 4, 7, 8].include?(number), number]
      end
    end
  end

  def detect_and_delete(connections, &block)
    connection = connections.detect(&block)
    connections.delete(connection)
  end
end
