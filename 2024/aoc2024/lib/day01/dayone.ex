defmodule Day01 do
  def read_lists(file_stream) do
    [list1, list2] = file_stream
    |> Stream.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Enum.to_list()
    {list1, list2}
  end

  @spec list_distance(list(), list()) :: number()
  def list_distance(list_1, list_2) do
    list_1
    |> Enum.sort()
    |> Enum.zip(list_2 |> Enum.sort())
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part_one(file_stream) do
    {list1, list2} = read_lists(file_stream)
    list_distance(list1, list2)
  end

  def main(_args \\ []) do
    IO.puts("Part 1: #{part_one(File.stream!("lib/day01/input.txt"))}")
    # IO.puts("Part 2: #{part_two()}")
  end
end
