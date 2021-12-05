# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/day_05'

class Day05Test < Minitest::Test
  def test_should_work_for_example
    assert_equal 5, DayFive.new("#{__dir__}/fixtures/day05.txt").run
  end

  def test_works_for_example_pt2
    assert_equal 12, DayFive.new("#{__dir__}/fixtures/day05.txt").run(diagonal: true)
  end
end
