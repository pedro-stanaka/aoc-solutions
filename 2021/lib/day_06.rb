# frozen_string_literal: true

# Day Six solution improved!
class DaySix
  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  NEW_BORN_TIMER = 8
  JUST_REPLICATED_TIMER = 6
  WILL_REPLICATE_TIMER = 0

  def run(days: 80)
    first_generation_tally = File.read(filename).split(',').map(&:to_i).tally

    fish_school = Hash.new(0)
    fish_school.merge!(first_generation_tally)

    days.times do
      new_born_tally = fish_school[WILL_REPLICATE_TIMER]

      # Shift over the fish on normal days
      8.times do |day|
        fish_school[day] = fish_school[day + 1]
      end
      fish_school[NEW_BORN_TIMER] = new_born_tally

      # Re-add the newly spawned to day 6
      fish_school[JUST_REPLICATED_TIMER] += new_born_tally
    end

    fish_school.values.sum
  end
end
