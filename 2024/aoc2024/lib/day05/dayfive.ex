defmodule Day05 do
  @moduledoc """
  Solution for Day 5 of Advent of Code 2024.
  Handles manual page ordering based on given rules.
  """

  defmodule Rule do
    @moduledoc """
    Represents a rule for page ordering, where `left` page must appear before `right` page.
    """
    @type t :: %__MODULE__{left: integer(), right: integer()}
    defstruct left: 0, right: 0

    def new([left, right]) do
        struct(Rule, left: left, right: right)
    end
  end

  defmodule OrderingRules do
    @moduledoc """
    Collection of rules that define the correct ordering of pages in manuals.
    """
    @type t :: %__MODULE__{rules: [Rule.t()]}
    defstruct rules: []

    def has?(%OrderingRules{rules: rules}, rule_number) do
      Enum.any?(rules, fn rule -> rule.left == rule_number or rule.right == rule_number end)
    end

    def populate(lines) do
        lines
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.split(&1, "|"))
        |> Stream.take_while(&(&1 != [""]))
        |> Stream.map(fn parts ->
          parts = Enum.map(parts, fn part ->
            part
            |> String.trim()
            |> String.to_integer()
          end)
          Rule.new(parts)
        end)
        |> Enum.to_list()
        |> then(&struct(OrderingRules, rules: &1))
    end
  end

  defmodule Instruction do
    @moduledoc """
    Represents a single instruction in a manual, with a rule number and its position in the sequence.
    """
    @type t :: %__MODULE__{rule: integer(), appearing_order: integer()}
    defstruct rule: 0, appearing_order: 0

    def new(rule, appearing_order) do
        struct(Instruction, rule: rule, appearing_order: appearing_order)
    end
  end

  defmodule Manual do
    @moduledoc """
    Represents a manual with a sequence of instructions that must follow certain ordering rules.
    """
    @type t :: %__MODULE__{instructions: [Instruction.t()]}
    defstruct instructions: []

    @doc """
    Returns the middle instruction of the manual.

    ### Examples

    iex> Day05.Manual.middle_instruction(%Day05.Manual{instructions: [
    ...>   %Day05.Instruction{rule: 1, appearing_order: 0},
    ...>   %Day05.Instruction{rule: 2, appearing_order: 1},
    ...>   %Day05.Instruction{rule: 3, appearing_order: 2}
    ...> ]})
    %Day05.Instruction{rule: 2, appearing_order: 1}
    """
    def middle_instruction(%Manual{instructions: instructions}) do
      instructions
      |> Enum.sort_by(& &1.appearing_order)
      |> Enum.at(div(length(instructions), 2))
    end

    def ordered?(%Manual{instructions: instructions} = manual, %OrderingRules{rules: rules}) do
      # for each rule (left|right), check if left appears before right
      Enum.all?(rules, fn rule ->
        not (has?(manual, rule.left) and has?(manual, rule.right)) or  # if either number is missing, rule is satisfied
        Enum.find_index(instructions, fn instruction -> instruction.rule == rule.left end) <
        Enum.find_index(instructions, fn instruction -> instruction.rule == rule.right end)
      end)
    end

    @spec has?(Manual.t(), integer()) :: boolean()
    defp has?(%Manual{instructions: instructions}, rule_number) do
      Enum.any?(instructions, fn instruction -> instruction.rule == rule_number end)
    end

    @doc """
    Returns a new Manual with the instructions reordered to satisfy the given rules.
    """
    def ordered(%Manual{instructions: instructions} = manual, %OrderingRules{rules: rules} = ruleset) do
        # base case: the manual is already ordered
        if ordered?(manual, ruleset) do
          manual
        else
          # check which rules are violated
          violated_rules = Enum.filter(rules, fn rule ->
            has?(manual, rule.left) and has?(manual, rule.right) and # only consider rules where both numbers exist
            Enum.find_index(instructions, fn instruction -> instruction.rule == rule.left end) >
            Enum.find_index(instructions, fn instruction -> instruction.rule == rule.right end)
          end)

          # Take the first violated rule and swap its elements
          case violated_rules do
            [rule | _] ->
              left_index = Enum.find_index(instructions, fn instruction -> instruction.rule == rule.left end)
              right_index = Enum.find_index(instructions, fn instruction -> instruction.rule == rule.right end)

              left_instruction = Enum.at(instructions, left_index)
              right_instruction = Enum.at(instructions, right_index)

              new_instructions = List.replace_at(instructions, left_index,
                %{right_instruction | appearing_order: left_instruction.appearing_order})
              |> List.replace_at(right_index,
                %{left_instruction | appearing_order: right_instruction.appearing_order})

              ordered(%Manual{instructions: new_instructions}, ruleset)

            [] -> manual
          end
        end
    end

    def populate(lines) do
        # skip all lines until the first empty line
        lines
        |> Stream.drop_while(&(&1 != "\n"))
        |> Stream.drop(1)
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.split(&1, ","))
        |> Stream.map(fn parts ->
          parts
          |> Enum.with_index()
          |> Enum.map(fn {rule, index} ->
            Instruction.new(String.to_integer(rule), index)
          end)
        end)
        |> Stream.map(&struct(Manual, instructions: &1))
        |> Enum.to_list()
    end
  end

  def part_one(filename) do
    ruleset =
        File.stream!(filename)
        |> OrderingRules.populate()

    manuals =
        File.stream!(filename)
        |> Manual.populate()

    manuals
    # only consider manuals that are already ordered
    |> Enum.filter(&Manual.ordered?(&1, ruleset))
    # get the middle instruction of each manual
    |> Enum.map(&Manual.middle_instruction/1)
    # take the rule of the middle instruction
    |> Enum.map(& &1.rule)
    # sum the rules
    |> Enum.sum()

  end

  def part_two(filename) do
    ruleset =
        File.stream!(filename)
        |> OrderingRules.populate()

    manuals =
        File.stream!(filename)
        |> Manual.populate()

    unordered_manuals =
        manuals
        |> Enum.filter(&not (Manual.ordered?(&1, ruleset)))

    unordered_manuals
    |> Enum.map(&Manual.ordered(&1, ruleset))
    # get the middle instruction of each manual
    |> Enum.map(&Manual.middle_instruction/1)
    # take the rule of the middle instruction
    |> Enum.map(& &1.rule)
    # sum the rules
    |> Enum.sum()
  end

  def main(_args) do
    IO.puts("Part one: #{part_one("lib/day05/input.txt")}")
    IO.puts("Part two: #{part_two("lib/day05/input.txt")}")
  end
end
