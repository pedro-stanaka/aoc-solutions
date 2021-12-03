# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/day_03'

# Test program coolness
class Day03Test < Minitest::Test
  def test_part1
    assert_equal({ gamma: 22, epsilon: 9 }, DayThree.new("#{__dir__}/fixtures/day03.txt").run)
  end

  def test_part2
    assert_equal({ depth: 60, horizon: 15, aim: 10 }, DayTwo::Solution.new("#{__dir__}/fixtures/day02.txt").run_part_two)
  end
end
