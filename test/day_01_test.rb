# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/day_01'

# Test program coolness
class Day01Test < Minitest::Test
  def test_coolness_off_the_charts
    assert_equal 5, DayOne.new("#{__dir__}/fixtures/day01.txt").run
  end
end
