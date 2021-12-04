class DayFour
  attr_reader :file_name

  ROW_SIZE = 5

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    numbers_string, rest = File.open(file_name) do |f|
      drawn_numbers = f.readline(chomp: true)
      f.readline # discard empty line
      rest = f.readlines(chomp: true)

      [drawn_numbers, rest]
    end

    drawn_numbers = numbers_string.split(',').map(&:to_i)
    puts drawn_numbers.inspect
    boards = build_boards(rest)
    scores = boards.size.times.map { Matrix.zero(ROW_SIZE) }

    winner = nil
    last_number = nil
    drawn_numbers.each do |n|
      boards.each_with_index do |b, i|
        next unless b.include? n

        r, c = b.index(n)
        b[r, c] = 0
        scores[i][r, c] = 1
      end
      winner = check_winner(scores)
      last_number = n
      puts last_number
      puts boards[68].inspect
      break unless winner.nil?
    end

    unless winner.nil?
      sum = boards[winner].sum
      puts boards.size
      puts "Last number #{last_number}"
      puts "Sum is: #{sum}"
      puts "The result is #{sum * last_number}"
    end

    puts "end"
  end

  private

  def check_winner(scores)
    winner = nil
    scores.each_with_index do |s, i|
      s.row_vectors.each do |row|
        winner = i if row.sum == ROW_SIZE
      end
    end

    winner
  end

  def build_boards(rest)
    boards = []
    board = []

    rest.each_with_index do |l, i|
      board.append(l.split.map(&:to_i)) if l != ""

      if l == "" || i == rest.size - 1
        boards.append(board)
        board = []
        next
      end
    end
    boards.map { |b| Matrix.rows(b) }
  end
end