defmodule Day07Test do
  use ExUnit.Case, async: true
  doctest Day07

  test "generate_permutations" do
    assert Enum.sort(Day07.Calibration.generate_permutations(2, [:+, :*])) ==
             Enum.sort([
               [:+, :+],
               [:*, :+],
               [:+, :*],
               [:*, :*]
             ])

    assert Enum.sort(Day07.Calibration.generate_permutations(3, [:+, :*])) ==
             Enum.sort([
               [:+, :+, :+],
               [:+, :+, :*],
               [:+, :*, :+],
               [:+, :*, :*],
               [:*, :+, :+],
               [:*, :+, :*],
               [:*, :*, :+],
               [:*, :*, :*]
             ])

    assert Enum.sort(Day07.Calibration.generate_permutations(2, [:+, :*, :concat])) ==
             Enum.sort([
               [:*, :*],
               [:*, :+],
               [:*, :concat],
               [:+, :*],
               [:+, :+],
               [:+, :concat],
               [:concat, :*],
               [:concat, :+],
               [:concat, :concat]
             ])
  end

  test "is_solvable?" do
    assert Day07.Calibration.solvable?(%Day07.Calibration{value: 190, operands: [10, 19]})
    assert Day07.Calibration.solvable?(%Day07.Calibration{value: 48, operands: [2, 3, 8]})
    refute Day07.Calibration.solvable?(%Day07.Calibration{value: 100, operands: [2, 3]})

    assert Day07.Calibration.solvable?(%Day07.Calibration{value: 1170, operands: [3, 65, 6]}, [
             :+,
             :*
           ])

    assert Day07.Calibration.solvable?(%Day07.Calibration{value: 156, operands: [15, 6]}, [
             :+,
             :*,
             :concat
           ])

    assert Day07.Calibration.solvable?(
             %Day07.Calibration{value: 7290, operands: [6, 8, 6, 15]},
             [:+, :*, :concat]
           )

    assert Day07.Calibration.solvable?(
             %Day07.Calibration{value: 192, operands: [17, 8, 14]},
             [:+, :*, :concat]
           )
  end

  test "parse_input" do
    assert Day07.parse_input([
             "24318: 4 78 74 7 9",
             "1170: 3 65 6"
           ]) == [
             %Day07.Calibration{value: 24_318, operands: [4, 78, 74, 7, 9]},
             %Day07.Calibration{value: 1170, operands: [3, 65, 6]}
           ]
  end
end
