defmodule Aoc2024 do
  @moduledoc """
  Main module for Advent of Code 2024 solutions.
  Provides a CLI interface to run solutions for different days.
  """

  @doc """
  Main entry point for the CLI application.
  Accepts a day number as argument and runs the corresponding solution.

  ## Some examples
      $ ./aoc2024 03  # Runs Day03 solution
      $ ./aoc2024 15  # Runs Day15 solution

  """
  def main(args) do
    case parse_args(args) do
      {:ok, day} ->
        run_day(day)

      {:error, reason} ->
        IO.puts(:stderr, "Error: #{reason}")
        System.halt(1)
    end
  end

  # Parse CLI arguments
  defp parse_args([day])
       when day in ~w(01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25) do
    {:ok, day}
  end

  defp parse_args([day]) when day in ~w(1 2 3 4 5 6 7 8 9) do
    {:ok, "0" <> day}
  end

  defp parse_args([]) do
    {:error, "Please provide a day number (01-25)"}
  end

  defp parse_args(_) do
    {:error, "Invalid day format. Please use a number between 1-25"}
  end

  # Run the solution for a specific day
  defp run_day(day) do
    module = String.to_existing_atom("Elixir.Day#{day}")

    if Code.ensure_loaded?(module) and function_exported?(module, :main, 1) do
      IO.puts("Running Day#{day} solution:")
      apply(module, :main, [[]])
    else
      IO.puts(:stderr, "Error: Day#{day} solution not implemented yet")
      System.halt(1)
    end
  rescue
    error ->
      IO.puts(:stderr, "Error: #{inspect(error)}")
      IO.puts(:stderr, "Error: Day#{day} module not found")
      System.halt(1)
  end
end
