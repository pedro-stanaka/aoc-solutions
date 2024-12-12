defmodule Day04 do
  @moduledoc """
  Solution for Day 4 of Advent of Code 2024.
  Handles word search puzzles in character matrices.
  """

  def part_one() do
    lines =
      File.read!("lib/day04/input.txt")
      |> String.split("\n")

    matrix = WordMatrix.populate(lines)
    WordMatrix.search(matrix, "XMAS")
  end

  def part_two() do
    lines =
      File.read!("lib/day04/input.txt")
      |> String.split("\n")

    matrix = WordMatrix.populate(lines)
    WordMatrix.search_x_mas(matrix)
  end

  def main(_args) do
    IO.puts("Part one: #{part_one()}")
    IO.puts("Part two: #{part_two()}")
  end
end
