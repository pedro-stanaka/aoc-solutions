defmodule Input do
  @moduledoc """
  Input module for Advent of Code 2024
  """

  def read_input(file_path) do
    File.stream!(file_path)
    |> Stream.map(&String.trim/1)
    |> Stream.filter(&(&1 != ""))
    |> Enum.to_list()
  end
end
