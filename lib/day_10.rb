# frozen_string_literal: true

## Solution for day 10
class DayTen
  L_PARENS = '('
  R_PARENS = ')'

  L_BRACKET = '{'
  R_BRACKET = '}'

  L_SQR_BRACKET = '['
  R_SQR_BRACKET = ']'

  L_CHEVRON = '<'
  R_CHEVRON = '>'

  MATCHING_PAIRS = {
    L_BRACKET => R_BRACKET,
    L_PARENS => R_PARENS,
    L_CHEVRON => R_CHEVRON,
    L_SQR_BRACKET => R_SQR_BRACKET,
  }.invert.freeze

  OPEN_CHARS = MATCHING_PAIRS.values

  ERROR_SCORE_MAP = {
    R_PARENS => 3,
    R_SQR_BRACKET => 57,
    R_BRACKET => 1197,
    R_CHEVRON => 25_137,
  }.freeze

  COMPLETION_SCORE_MAP = {
    R_PARENS => 1,
    R_SQR_BRACKET => 2,
    R_BRACKET => 3,
    R_CHEVRON => 4,
  }.freeze

  attr_reader :file_name

  include FileReader

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    read_file(file_name).inject(0) do |score, line|
      parser_stack = []

      line.split('').each do |char|
        if OPEN_CHARS.include? char
          parser_stack.push(char)
        elsif MATCHING_PAIRS[char] != parser_stack.pop
          score += ERROR_SCORE_MAP[char]
        end
      end

      score
    end
  end

  def run_pt2
    score_list = []

    read_file(file_name).each do |line|
      corrupted_line = false

      line_stack = []
      line.each_char do |c|
        break if corrupted_line

        if OPEN_CHARS.include? c
          line_stack.push c
          # puts "enqueued #{c}"
        elsif line_stack.last == MATCHING_PAIRS[c]
          line_stack.pop
        else
          corrupted_line = true
          next
        end
      end

      puts "done processing line. corrupted = #{corrupted_line.inspect}"

      next if corrupted_line

      line_score = line_stack.reverse.inject(0) do |score, c|
        score * 5 + COMPLETION_SCORE_MAP[MATCHING_PAIRS.invert[c]]
      end

      score_list.push line_score
    end

    score_list.sort[score_list.size / 2]
  end
end
