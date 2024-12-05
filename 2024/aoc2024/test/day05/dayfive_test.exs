defmodule Day05Test do
  use ExUnit.Case
  doctest Day05
  doctest Day05.Manual
  doctest Day05.Rule
  doctest Day05.OrderingRules

  @sample_rules %Day05.OrderingRules{
    rules: [
      %Day05.Rule{left: 47, right: 53},
      %Day05.Rule{left: 97, right: 13},
      %Day05.Rule{left: 97, right: 61},
      %Day05.Rule{left: 97, right: 47},
      %Day05.Rule{left: 75, right: 29},
      %Day05.Rule{left: 61, right: 13},
      %Day05.Rule{left: 75, right: 53},
      %Day05.Rule{left: 29, right: 13},
      %Day05.Rule{left: 97, right: 29},
      %Day05.Rule{left: 53, right: 29},
      %Day05.Rule{left: 61, right: 53},
      %Day05.Rule{left: 97, right: 53},
      %Day05.Rule{left: 61, right: 29},
      %Day05.Rule{left: 47, right: 13},
      %Day05.Rule{left: 75, right: 47},
      %Day05.Rule{left: 97, right: 75},
      %Day05.Rule{left: 47, right: 61},
      %Day05.Rule{left: 75, right: 61},
      %Day05.Rule{left: 47, right: 29},
      %Day05.Rule{left: 75, right: 13},
      %Day05.Rule{left: 53, right: 13}
    ]
  }
  test "OrderingRules.populate" do
    assert Day05.OrderingRules.populate([
      "47|53\n",
      "97|13\n",
      "\n",
      "18,10,22\n"
    ]) == %Day05.OrderingRules{
      rules: [
        %Day05.Rule{left: 47, right: 53},
        %Day05.Rule{left: 97, right: 13}
      ]
    }
  end

  test "Manual.populate" do
    assert Day05.Manual.populate([
      "47|53\n",
      "97|13\n",
      "\n",
      "18,10,22\n",
      "10,29,22\n",
    ]) == [
      %Day05.Manual{
        instructions: [
          %Day05.Instruction{rule: 18, appearing_order: 0},
          %Day05.Instruction{rule: 10, appearing_order: 1},
          %Day05.Instruction{rule: 22, appearing_order: 2},
        ]
      },
      %Day05.Manual{
        instructions: [
          %Day05.Instruction{rule: 10, appearing_order: 0},
          %Day05.Instruction{rule: 29, appearing_order: 1},
          %Day05.Instruction{rule: 22, appearing_order: 2},
        ]
      }
    ]
  end

  test "Manual.middle_instruction" do
    assert Day05.Manual.middle_instruction(
      %Day05.Manual{
        instructions: [
          %Day05.Instruction{rule: 47, appearing_order: 0},
          %Day05.Instruction{rule: 97, appearing_order: 1},
          %Day05.Instruction{rule: 18, appearing_order: 2},
        ]
      }
    ) == %Day05.Instruction{rule: 97, appearing_order: 1}
  end

  test "integration manual and ordering" do
    example_input = [
      "47|53\n",
      "97|13\n",
      "97|61\n",
      "97|47\n",
      "75|29\n",
      "61|13\n",
      "75|53\n",
      "29|13\n",
      "97|29\n",
      "53|29\n",
      "61|53\n",
      "97|53\n",
      "61|29\n",
      "47|13\n",
      "75|47\n",
      "97|75\n",
      "47|61\n",
      "75|61\n",
      "47|29\n",
      "75|13\n",
      "53|13\n",
      "\n",
      "75,47,61,53,29\n",
      "97,61,53,29,13\n",
      "75,29,13\n",
      "75,97,47,61,53\n",
      "61,13,29\n",
      "97,13,75,29,47\n"
    ]

    ruleset = Day05.OrderingRules.populate(example_input)
    assert Day05.OrderingRules.has?(ruleset, 97), "example ruleset should have rule 97"
    manuals = Day05.Manual.populate(example_input)
    ordered_manuals = manuals
      |> Enum.filter(&Day05.Manual.ordered?(&1, ruleset))
    assert length(ordered_manuals) == 3 # the first 3 manuals are ordered
  end

  test "Manual.ordered?" do
    rules = @sample_rules
    test_cases = [
      # Manual 1: "75,47,61,53,29"
      {
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 75, appearing_order: 0},
            %Day05.Instruction{rule: 47, appearing_order: 1},
            %Day05.Instruction{rule: 61, appearing_order: 2},
            %Day05.Instruction{rule: 53, appearing_order: 3},
            %Day05.Instruction{rule: 29, appearing_order: 4},
          ]
        },
        rules,
        true  # This should be ordered because:
        # 75 appears before 47 (75|47)
        # 75 appears before 61 (75|61)
        # 75 appears before 53 (75|53)
        # 75 appears before 29 (75|29)
        # 47 appears before 61 (47|61)
        # 47 appears before 53 (47|53)
        # 47 appears before 29 (47|29)
        # 61 appears before 53 (61|53)
        # 61 appears before 29 (61|29)
        # 53 appears before 29 (53|29)
      },

      # Manual 2: "97,61,53,29,13"
      {
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 97, appearing_order: 0},
            %Day05.Instruction{rule: 61, appearing_order: 1},
            %Day05.Instruction{rule: 53, appearing_order: 2},
            %Day05.Instruction{rule: 29, appearing_order: 3},
            %Day05.Instruction{rule: 13, appearing_order: 4},
          ]
        },
        rules,
        true  # This should be ordered because:
        # 97 -> 13 (satisfied: 13 appears after 97)
        # 97 -> 61 (satisfied: 61 appears after 97)
        # 61 -> 13 (satisfied: 13 appears after 61)
        # 53 -> 29 (satisfied: 29 appears after 53)
      },

      # Manual 3: "75,29,13"
      {
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 75, appearing_order: 0},
            %Day05.Instruction{rule: 29, appearing_order: 1},
            %Day05.Instruction{rule: 13, appearing_order: 2},
          ]
        },
        rules,
        true  # This should be ordered because:
        # 75 -> 29 (satisfied: 29 appears after 75)
        # 29 -> 13 (satisfied: 13 appears after 29)
      },

      # Manual 4: "75,97,47,61,53"
      {
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 75, appearing_order: 0},
            %Day05.Instruction{rule: 97, appearing_order: 1},
            %Day05.Instruction{rule: 47, appearing_order: 2},
            %Day05.Instruction{rule: 61, appearing_order: 3},
            %Day05.Instruction{rule: 53, appearing_order: 4},
          ]
        },
        rules,
        false  # This should be unordered because:
        # 97 -> 47 is violated (47 appears after 97)
      }
    ]

    for {manual, rules, expected} <- test_cases do
      assert Day05.Manual.ordered?(manual, rules) == expected,
             "Expected manual \n#{inspect(manual)}\nwith rules \n#{inspect(rules)}\nto be #{if expected, do: "ordered", else: "unordered"}"
    end
  end

  test "Manual.ordered" do
    rules = @sample_rules

    test_cases = [
      {
        # 75,97,47,61,53 becomes 97,75,47,61,53.
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 75, appearing_order: 0},
            %Day05.Instruction{rule: 97, appearing_order: 1},
            %Day05.Instruction{rule: 47, appearing_order: 2},
            %Day05.Instruction{rule: 61, appearing_order: 3},
            %Day05.Instruction{rule: 53, appearing_order: 4},
          ]
        },
        rules,
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 97, appearing_order: 0},
            %Day05.Instruction{rule: 75, appearing_order: 1},
            %Day05.Instruction{rule: 47, appearing_order: 2},
            %Day05.Instruction{rule: 61, appearing_order: 3},
            %Day05.Instruction{rule: 53, appearing_order: 4},
          ]
        }
      },
      {
        # 61,13,29 becomes 61,29,13.
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 61, appearing_order: 0},
            %Day05.Instruction{rule: 13, appearing_order: 1},
            %Day05.Instruction{rule: 29, appearing_order: 2},
          ]
        },
        rules,
        %Day05.Manual{
          instructions: [
            %Day05.Instruction{rule: 61, appearing_order: 0},
            %Day05.Instruction{rule: 29, appearing_order: 1},
            %Day05.Instruction{rule: 13, appearing_order: 2},
          ]
        }
      }
    ]

    for {manual, rules, expected} <- test_cases do
      assert Day05.Manual.ordered(manual, rules) == expected
      assert Day05.Manual.ordered?(expected, rules)
    end
  end
end
