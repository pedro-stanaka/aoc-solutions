defmodule Day07 do
  defmodule Calibration do
    defstruct value: 0, operands: []

    @type t :: %__MODULE__{
            value: integer(),
            operands: [integer()]
          }

    @spec new(integer(), [integer()]) :: t()
    def new(value, operands) do
      %Day07.Calibration{value: value, operands: operands}
    end

    def format(calibration, operators) do
      # Pair each operand except the last with an operator
      {init_operands, [last_operand]} = Enum.split(calibration.operands, -1)
      operands_with_operators = Enum.zip(init_operands, operators)

      # Format all but the last operand with their operators
      formatted_operands =
        Enum.map(operands_with_operators, fn {operand, operator} ->
          "#{operand} #{operator}"
        end)

      # Add the last operand without an operator
      all_formatted = formatted_operands ++ [to_string(last_operand)]

      "#{calibration.value}: #{Enum.join(all_formatted, " ")}"
    end

    def solvable?(%Calibration{} = calibration) do
      solvable?(calibration, [:+, :*])
    end

    def solvable?(%Calibration{} = calibration, allowed_operators) do
      perms = generate_permutations(length(calibration.operands) - 1, allowed_operators)

      Enum.any?(perms, fn operators ->
        correct?(calibration, operators)
      end)
    end

    defp correct?(%Calibration{value: value, operands: operands}, operators) do
      # Zip the operators with pairs of operands and evaluate
      operand_pairs = Enum.chunk_every(operands, 2, 1, :discard)
      operations = Enum.zip(operand_pairs, operators)

      result =
        Enum.reduce(operations, hd(operands), fn
          {[_a, b], :+}, acc -> acc + b
          {[_a, b], :*}, acc -> acc * b
          {[_a, b], :concat}, acc -> String.to_integer(to_string(acc) <> to_string(b))
        end)

      result == value
    end

    def generate_permutations(num_operators, allowed_operators) do
      for _ <- 1..num_operators,
          reduce: [[]] do
        acc ->
          for op <- allowed_operators,
              list <- acc do
            list ++ [op]
          end
      end
    end
  end

  @doc """
  Parses the input into a list of lists of Calibration(s).

  ### Examples
  ```
  iex> Day07.parse_input(["24318: 4 78 74 7 9"])
  [%Day07.Calibration{value: 24318, operands: [4, 78, 74, 7, 9]}]
  ```
  """
  def parse_input(lines) do
    lines
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ":"))
    |> Stream.map(fn [value, operands] ->
      %Calibration{
        value: String.to_integer(value),
        operands:
          operands
          |> String.trim()
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)
      }
    end)
    |> Enum.to_list()
  end

  def part_one(file_name) do
    file_name
    |> File.stream!()
    |> parse_input()
    |> Enum.filter(&Calibration.is_solvable?/1)
    |> Enum.map(& &1.value)
    |> Enum.sum()
  end

  def part_two(file_name) do
    file_name
    |> File.stream!()
    |> parse_input()
    |> Enum.filter(&Calibration.is_solvable?(&1, [:+, :*, :concat]))
    |> Enum.map(& &1.value)
    |> Enum.sum()
  end

  def main(_) do
    file_name = "lib/day07/input.txt"
    IO.puts(part_one(file_name))
    IO.puts(part_two(file_name))
  end
end
