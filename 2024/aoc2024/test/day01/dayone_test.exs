defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "read_lists" do
    input = [
      "3   4\n",
      "4   3\n",
      "2   5\n",
      "1   3\n",
      "3   9\n",
      "3   3\n"
    ]

    assert Day01.read_lists(input) == {
             [3, 4, 2, 1, 3, 3],
             [4, 3, 5, 3, 9, 3]
           }
  end
end
