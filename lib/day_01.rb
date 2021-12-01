# frozen_string_literal: true

# The coolest program
class DayOne
  attr_reader :file_name
  def initialize(file_name)
    @file_name = file_name
  end

  def run
    file = File.open(file_name)

  end
end
