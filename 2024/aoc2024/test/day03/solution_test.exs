defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "parse_mul" do
    assert Day03.parse_mul("mul(2,4)") == [%{"a" => 2, "b" => 4}]
  end

  test "parse_mul multiple" do
    assert Day03.parse_mul("mul(2,4) mul(3,7)") == [%{"a" => 2, "b" => 4}, %{"a" => 3, "b" => 7}]
  end

  test "sum_of_products" do
    assert Day03.sum_of_products(["mul(2,4) mul(3,7)"]) == 29
  end

  test "example input" do
    assert Day03.sum_of_products(["xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"]) == 161
  end

  test "parse_mul_conditional" do
    test_cases = [
      {
        "example from part two",
        "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))",
        [%{"a" => 2, "b" => 4}, %{"a" => 8, "b" => 5}]  # only first mul and last mul (after do()) are enabled
      },
      {
        "disabled and enabled sequence",
        "mul(1,2)don't()mul(3,4)mul(4,5)do()mul(5,6)mul(7,8)",
        [%{"a" => 1, "b" => 2}, %{"a" => 5, "b" => 6}, %{"a" => 7, "b" => 8}]  # first mul and all muls after do() are enabled
      },
      {
        "multiple disabled and enabled sequences",
        "mul(1,2)don't()mul(3,4)mul(9,10)do()mul(5,6)mul(7,8)don't()mul(11,12)do()mul(13,14)",
        [%{"a" => 1, "b" => 2}, %{"a" => 5, "b" => 6}, %{"a" => 7, "b" => 8}, %{"a" => 13, "b" => 14}]
      },
      {
        "complex sequence with multiple controls",
        "]};don't(){^mul(131,421)who()+where()why()why() mul)who()from(361,208)#($>/mul(986,7)~!/+:what(911,564)&~mul(427,317):<how()[-+?from()*do()??$'why(),$#,(mul(388,863)]$;mul(93,214)${from(),>mul(554,29)",
        [%{"a" => 388, "b" => 863}, %{"a" => 93, "b" => 214}, %{"a" => 554, "b" => 29}]  # all muls after last do() are enabled
      },
      {
        "do() vs undo()",
        "mul(1,2)undo()mul(3,4)do()mul(5,6)",
        # undo is not a command, so it should treat do() and consider all muls after it enabled
        [%{"a" => 1, "b" => 2}, %{"a" => 3, "b" => 4}, %{"a" => 5, "b" => 6}]
      },
      {
        "do() inside other words",
        "do()mul(449,81)*where()(<mul(87,134)#why()?don't(), -mul(905,619)who()((mul(211,136)what()&&?{;select()!what(38,53)mul(926,865)how()/%mul(317,285)(?^,-mul(450,990)from(269,194)\#{*why()from()why()-<mul(388,169)$&,'undo()@?when()%}~mul(481,655)",
        [
          # First two muls enabled by initial do()
          %{"a" => 449, "b" => 81},
          %{"a" => 87, "b" => 134},
          # Last mul enabled by do() inside undo()
          %{"a" => 481, "b" => 655}
        ]
      }
    ]

    for {description, input, expected} <- test_cases do
      actual = Day03.parse_mul_conditional(input)
      assert actual == expected,
             """
             Failed test case: #{description}
             Expected: #{inspect(expected, pretty: true)}
             Got:      #{inspect(actual, pretty: true)}
             Input:    #{input}
             """
    end
  end
end
