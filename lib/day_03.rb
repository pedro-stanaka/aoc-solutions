# frozen_string_literal: true

require_relative 'ioutil/file_reader'
require 'matrix'

class DayThree
  attr_reader :file_name

  include FileReader

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    lines = read_file(file_name).map { |l| l.scan(/\w/).map(&:to_i) }
    report_matrix = Matrix.rows(lines)

    gamma_str = ''
    epsilon_str = ''

    report_matrix.column_vectors.each do |col|
      col_str = col.to_a.map(&:to_s).join('')
      count_zeros = col_str.scan(/0/).count
      count_ones = col_str.scan(/1/).count

      if count_zeros > count_ones
        gamma_str += '0'
        epsilon_str += '1'
      else
        gamma_str += '1'
        epsilon_str += '0'
      end
    end

    { gamma: gamma_str.to_i(2), epsilon: epsilon_str.to_i(2) }
  end
end
