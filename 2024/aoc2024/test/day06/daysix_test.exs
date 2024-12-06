defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  test "Map.populate" do
    actual =  Day06.Map.populate([
      "....#.....\n",
      ".........#\n",
      "..........\n",
      "..#.......\n",
      ".......#..\n",
      "..........\n",
      ".#..^.....\n",
      "........#.\n",
      "#.........\n",
      "......#...\n"
    ])

    # assert shape
    assert length(actual.rows) == 10
    assert length(hd(actual.rows)) == 10

    assert actual == %Day06.Map{
      guard: %{direction: %{dx: 0, dy: -1}, pos: %Day06.Coord{x: 4, y: 6}},
      obstacles: [
        %Day06.Coord{x: 4, y: 0},
        %Day06.Coord{x: 9, y: 1},
        %Day06.Coord{x: 2, y: 3},
        %Day06.Coord{x: 7, y: 4},
        %Day06.Coord{x: 1, y: 6},
        %Day06.Coord{x: 8, y: 7},
        %Day06.Coord{x: 0, y: 8},
        %Day06.Coord{x: 6, y: 9}
      ],
      rows: [
        [".", ".", ".", ".", "#", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", ".", ".", "#"],
        [".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
        [".", ".", "#", ".", ".", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", "#", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
        [".", "#", ".", ".", "^", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", ".", ".", "#", "."],
        ["#", ".", ".", ".", ".", ".", ".", ".", ".", "."],
        [".", ".", ".", ".", ".", ".", "#", ".", ".", "."],
      ],
    }
  end

  test "Map.count_visiting_positions" do
    actual =  Day06.Map.populate([
      "....#.....\n",
      ".........#\n",
      "..........\n",
      "..#.......\n",
      ".......#..\n",
      "..........\n",
      ".#..^.....\n",
      "........#.\n",
      "#.........\n",
      "......#...\n"
    ])

    visited_positions = Day06.Map.guard_routine(actual) |> MapSet.to_list()
    assert length(visited_positions) == 41,
      """
      Expected 41 visiting positions, got #{length(visited_positions)}.
      Map:
      #{Day06.Map.show_guard_routine(actual)}
      """
  end

end
