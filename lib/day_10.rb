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

  SCORE_MAP = {
    R_PARENS => 3,
    R_SQR_BRACKET => 57,
    R_BRACKET => 1197,
    R_CHEVRON => 25_137,
  }.freeze

  attr_reader :file_name

  include FileReader

  def initialize(file_name)
    @file_name = file_name
  end

  def run
    score = 0

    read_file(file_name).each do |line|
      parser_stack = []

      line.split('').each do |char|
        case char
        when L_BRACKET, L_SQR_BRACKET, L_CHEVRON, L_PARENS
          parser_stack.push(char)
        when R_SQR_BRACKET
          score += SCORE_MAP[R_SQR_BRACKET] if parser_stack.pop != L_SQR_BRACKET
        when R_CHEVRON
          score += SCORE_MAP[R_CHEVRON] if parser_stack.pop != L_CHEVRON
        when R_PARENS
          score += SCORE_MAP[R_PARENS] if parser_stack.pop != L_PARENS
        when R_BRACKET
          score += SCORE_MAP[R_BRACKET] if parser_stack.pop != L_BRACKET
        else
          raise "Unknown char: #{char}"
        end
      end
    end

    score
  end

  def run_pt2
    score = 0

    score += 1

    score
  end
end
