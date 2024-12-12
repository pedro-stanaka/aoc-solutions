defmodule Day03 do
  @moduledoc """
  Day 3: Mull It Over
  """

  @type operation :: {:mul, map()} | :do | :dont
  @type state :: %{enabled: boolean(), acc: list()}

  @doc """
  Parse a line of input into a list of mul operations.
  At the beginning of the program, mul instructions are enabled.
  A do() instruction enables future mul instructions.
  A don't() instruction disables future mul instructions.

  ## Examples

      iex> Day03.parse_mul_conditional("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
      [%{"a" => 2, "b" => 4}, %{"a" => 8, "b" => 5}]

  """
  def parse_mul_conditional(line) do
    line
    |> String.to_charlist()
    |> Stream.unfold(&next_operation/1)
    |> Stream.reject(&is_nil/1)
    |> Enum.reduce(%{enabled: true, acc: []}, &process_operation/2)
    |> Map.get(:acc)
    |> Enum.reverse()
  end

  # Find the next operation in the input stream
  defp next_operation([]), do: nil

  defp next_operation(chars) do
    cond do
      match?(~c"do()" ++ _, chars) ->
        {:do, Enum.drop(chars, 4)}

      match?(~c"don't()" ++ _, chars) ->
        {:dont, Enum.drop(chars, 7)}

      match?(~c"mul(" ++ _, chars) ->
        case parse_mul_numbers(chars) do
          {:ok, nums, rest} -> {{:mul, nums}, rest}
          :error -> {nil, tl(chars)}
        end

      true ->
        {nil, tl(chars)}
    end
  end

  # Parse the numbers in a mul operation
  defp parse_mul_numbers(~c"mul(" ++ rest) do
    with {num1, ~c"," ++ rest2} <- parse_number(rest),
         {num2, ~c")" ++ rest3} <- parse_number(rest2),
         true <- num1 <= 999 and num2 <= 999 do
      {:ok, %{"a" => num1, "b" => num2}, rest3}
    else
      _ -> :error
    end
  end

  # Parse a number from the start of the char list
  defp parse_number(chars) do
    {digits, rest} = Enum.split_while(chars, &(&1 in ?0..?9))

    case digits do
      [] -> :error
      ds -> {List.to_integer(ds), rest}
    end
  end

  # Process each operation and update state
  defp process_operation(:do, state), do: %{state | enabled: true}
  defp process_operation(:dont, state), do: %{state | enabled: false}

  defp process_operation({:mul, nums}, %{enabled: true} = state) do
    %{state | acc: [nums | state.acc]}
  end

  defp process_operation({:mul, _nums}, state), do: state
  defp process_operation(nil, state), do: state

  @spec mul(number(), number()) :: number()
  def mul(a, b), do: a * b

  defp multiply_and_sum(muls) do
    muls
    |> Enum.map(fn %{"a" => a, "b" => b} -> mul(a, b) end)
    |> Enum.sum()
  end

  def parse_mul(line) do
    ~r/mul\((?<a>\d{1,3}),(?<b>\d{1,3})\)/
    |> Regex.scan(line, capture: :all_names)
    |> Stream.map(fn [a, b] ->
      %{"a" => String.to_integer(a), "b" => String.to_integer(b)}
    end)
    |> Enum.to_list()
  end

  @spec sum_of_products(list(String.t())) :: number()
  def sum_of_products(lines) do
    lines
    |> Stream.map(&parse_mul/1)
    |> Stream.map(&multiply_and_sum/1)
    |> Enum.sum()
  end

  def part_one do
    Input.read_input("lib/day03/input.txt")
    |> sum_of_products()
  end

  def part_two do
    Input.read_input("lib/day03/input.txt")
    |> Enum.join("")
    |> String.replace(~r/\s+/, "")
    |> parse_mul_conditional()
    |> multiply_and_sum()
  end

  def main(_args \\ []) do
    IO.puts("Part 1: #{part_one()}")
    IO.puts("Part 2: #{part_two()}")
  end
end
