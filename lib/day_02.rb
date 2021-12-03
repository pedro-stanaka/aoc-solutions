# frozen_string_literal: true

require_relative 'ioutil/file_reader'

module DayTwo
  ## DayTwo solution for AoC
  class Solution
    include FileReader

    def initialize(file_name)
      @file_name = file_name
    end

    def run
      coords = { depth: 0, horizon: 0 }

      read_file(@file_name).each do |command|
        coords = parse_command(command, coords)
      end

      coords
    end

    def run_part_two
      coords = { depth: 0, horizon: 0, aim: 0 }

      read_file(@file_name).each do |command|
        coords = parse_command_with_aim(command, coords)
      end

      coords
    end

    private

    def parse_command(command, coords)
      direction, amount = command.split
      amount = amount.to_i

      case direction
      when 'up'
        coords[:depth] -= amount
      when 'down'
        coords[:depth] += amount
      when 'forward'
        coords[:horizon] += amount
      else
        puts "unknown direction #{direction}"
      end

      coords
    end

    def parse_command_with_aim(command, coords)
      direction, amount = command.split
      amount = amount.to_i

      case direction
      when 'up'
        coords[:aim] -= amount
      when 'down'
        coords[:aim] += amount
      when 'forward'
        coords[:horizon] += amount
        coords[:depth] += (coords[:aim] * amount)
      else
        puts "unknown direction #{direction}"
      end

      coords
    end
  end
end
