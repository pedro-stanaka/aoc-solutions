# frozen_string_literal: true

require 'benchmark'

class DaySix
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  NEW_BORN_TIMER = 8
  JUST_REPLICATED_TIMER = 6
  WILL_REPLICATE_TIMER = 0

  def run(days: 80)
    lantern_fish_timer = File.read(filename).split(',').map(&:to_i)

    days.times.each do |day|
      elapsed = Benchmark.realtime do
        new_fish_school = []
        new_born = []

        lantern_fish_timer.each do |timer|
          case timer
          when WILL_REPLICATE_TIMER
            new_fish_school.append(JUST_REPLICATED_TIMER)
            new_born.append(NEW_BORN_TIMER)
          else
            new_fish_school.append(timer - 1)
          end
        end

        # puts "Old size: #{lantern_fish_timer.size}. New born: #{new_born.size}"
        lantern_fish_timer = new_fish_school + new_born
      end
      # puts lantern_fish_timer.select { |t| t == WILL_REPLICATE_TIMER }.size
      puts "Day: #{day} - Fish School size: #{lantern_fish_timer.size} - Elapsed: #{elapsed}"
    end

    lantern_fish_timer
  end
end
