class DayFive
  include FileReader

  attr_reader :file_name, :previous_winners

  ROW_SIZE = 5

  def initialize(file_name)
    @file_name = file_name
    @previous_winners = []
  end

  def run
    lines = read_file(file_name).map { |l| l.split(" -> ") }
    puts lines.inspect
  end
end