class DayFour
  attr_reader :file_name, :previous_winners

  ROW_SIZE = 5

  def initialize(file_name)
    @file_name = file_name
    @previous_winners = []
  end

  def run
    drawn_numbers, boards = File.open(file_name) do |f|
      drawn_numbers = f.readline(chomp: true).split(',').map(&:to_i)
      f.readline # discard empty line
      rest = f.readlines(chomp: true)

      [drawn_numbers, build_boards(rest)]
    end

    scores = boards.size.times.map { Matrix.zero(ROW_SIZE) }

    last_winning_number = nil
    last_winner = nil
    last_board_state = nil
    drawn_numbers.each do |n|
      boards.each_with_index do |b, i|
        next unless b.include? n

        puts "Number: #{n} - Board ##{i}"
        puts b.inspect
        r, c = b.index(n)
        b[r, c] = 0
        scores[i][r, c] = 1
        puts b.inspect
      end
      puts "---- #{scores.size}"
      winner = check_winner(scores)
      last_number = n
      unless winner.nil?
        last_winning_number = last_number
        until winner.nil?
          puts winner
          last_board_state = boards[winner].clone
          boards.delete_at(winner)
          scores.delete_at(winner)
          winner = check_winner(scores)
        end
      end
      winner = nil
    end

    unless last_board_state.nil?
      sum = last_board_state.sum
      puts "Winner index #{last_winner}"
      puts "Last number #{last_winning_number}"
      puts "The result is #{sum * last_winning_number}"
    end
  end

  private

  def check_winner(scores)
    winner = nil
    scores.each_with_index do |s, i|
      s.row_vectors.each do |row|
        if row.sum == ROW_SIZE
          winner = i
          break
        end
        break unless winner.nil?
      end

      s.column_vectors.each do |col|
        if col.sum == ROW_SIZE
          winner = i
          break
        end
        break unless winner.nil?
      end

      break unless winner.nil?
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