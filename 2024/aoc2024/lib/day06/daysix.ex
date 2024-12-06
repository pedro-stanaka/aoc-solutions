defmodule Day06 do
    defmodule Coord do
        defstruct x: 0, y: 0

        def distance(a, b) do
            abs(a.x - b.x) + abs(a.y - b.y)
        end
    end

    defmodule Map do
        defstruct rows: [], obstacles: [], guard: %{ pos: nil, direction: %{ dx: 0, dy: 1} }

        @doc """
        Populates the map from a list/stream of lines.
        Each "." represents an empty space, and each "#" represents an obstacle.
        A single "^" represents the guard's position, always "walking" upwards (at the start).
        """
        def populate(lines) do
            rows = lines
            |> Enum.map(&String.trim/1)
            |> Enum.map(&String.graphemes/1)

            obstacles = for {row, y} <- Enum.with_index(rows),
                           {cell, x} <- Enum.with_index(row),
                           cell == "#",
                           do: %Coord{x: x, y: y}

            guard_pos = for {row, y} <- Enum.with_index(rows),
                        {cell, x} <- Enum.with_index(row),
                        cell == "^",
                        do: %Coord{x: x, y: y}

            guard = %{pos: hd(guard_pos), direction: %{dx: 0, dy: 1}}

            %Map{rows: rows, obstacles: obstacles, guard: guard}
        end
    end
end
