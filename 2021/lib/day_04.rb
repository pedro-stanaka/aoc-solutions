# frozen_string_literal: true

## Day 04 Solution
class DayFour
  attr_reader :file_name, :boards, :scores

  ROW_SIZE = 5

  def initialize(file_name)
    @file_name = file_name
  end

  def run_pt2
    @boards, drawn_numbers = draw_numbers_and_boards

    @scores = boards.size.times.map { Matrix.zero(ROW_SIZE) }

    last_winning_number = nil
    last_board_state = nil
    drawn_numbers.each do |n|
      mark_number_in_boards(n)

      winner = check_winner(scores)
      next if winner.nil?

      last_winning_number = n
      until winner.nil?
        last_board_state = boards[winner].clone
        boards.delete_at(winner)
        scores.delete_at(winner)
        winner = check_winner(scores)
      end
    end

    return if last_board_state.nil?

    sum = last_board_state.sum
    puts "The result is #{sum * last_winning_number}"
  end

  def run
    boards, drawn_numbers = draw_numbers_and_boards

    scores = boards.size.times.map { Matrix.zero(ROW_SIZE) }

    last_number = nil
    winner = nil

    drawn_numbers.each do |n|
      mark_number_in_boards(n)
      winner = check_winner(scores)
      last_number = n
      break unless winner.nil?
    end

    return if winner.nil?

    sum = boards[winner].sum
    puts "The result is #{sum * last_number}"
  end

  private

  def mark_number_in_boards(n)
    boards.each_with_index do |b, i|
      next unless b.include? n

      r, c = b.index(n)
      b[r, c] = 0
      scores[i][r, c] = 1
    end
  end

  def draw_numbers_and_boards
    drawn_numbers, boards = File.open(file_name) do |f|
      drawn_numbers = f.readline(chomp: true).split(',').map(&:to_i)
      f.readline # discard empty line
      rest = f.readlines(chomp: true)

      [drawn_numbers, build_boards(rest)]
    end

    [boards, drawn_numbers]
  end

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
      board.append(l.split.map(&:to_i)) if l != ''

      next unless l == '' || i == rest.size - 1

      boards.append(board)
      board = []
    end

    boards.map { |b| Matrix.rows(b) }
  end
end
