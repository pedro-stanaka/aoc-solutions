# frozen_string_literal: true

require_relative 'ioutil/file_reader'
require 'matrix'

class DayThree
  attr_reader :file_name

  include FileReader

  OXYGEN_RATE = 'oxygen'
  CO2_SCRUBBER = 'scrubber'

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    lines = read_file(file_name).map { |l| l.scan(/\w/).map(&:to_i) }
    report_matrix = Matrix.rows(lines)

    find_gamma_epsilon(report_matrix)
  end

  def run_pt2
    lines = read_file(file_name).map { |l| l.scan(/\w/).map(&:to_i) }
    report_matrix = Matrix.rows(lines)

    find_oxygen_scrubber(report_matrix)
  end

  private

  def find_oxygen_scrubber(report_matrix)
    oxygen_rate = find_rate(report_matrix, OXYGEN_RATE)
    co2_scrubber_rate = find_rate(report_matrix, CO2_SCRUBBER)

    { oxygen: oxygen_rate.to_i(2), co2: co2_scrubber_rate.to_i(2) }
  end

  def find_rate(report_matrix, rate_name, cur_col = 0)
    if report_matrix.row_vectors.count == 1 || cur_col >= report_matrix.column_count
      return report_matrix.row_vectors[0].to_a.map(&:to_s).join('')
    end

    common, least = find_most_least_common_binary(report_matrix.column(cur_col))
    filter_bit = (rate_name == OXYGEN_RATE ? common : least)

    new_matrix = Matrix.rows(report_matrix.row_vectors.filter { |r| r[cur_col] == filter_bit })

    return find_rate(new_matrix, rate_name, cur_col + 1) if rate_name == OXYGEN_RATE

    find_rate(new_matrix, rate_name, cur_col + 1)
  end

  def find_gamma_epsilon(report_matrix)
    gamma_str = ''
    epsilon_str = ''

    report_matrix.column_vectors.each do |col|
      most_common, least_common = find_most_least_common_binary(col)

      gamma_str += most_common.to_s
      epsilon_str += least_common.to_s
    end

    { gamma: gamma_str.to_i(2), epsilon: epsilon_str.to_i(2) }
  end

  def find_most_least_common_binary(vector)
    col_str = vector.to_a.map(&:to_s).join('')
    count_zeros = col_str.scan(/0/).count
    count_ones = col_str.scan(/1/).count

    return [0, 1] if count_zeros > count_ones

    [1, 0]
  end
end
