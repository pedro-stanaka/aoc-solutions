defmodule Day06 do
    defmodule Coord do
        defstruct x: 0, y: 0

        def distance(a, b) do
            abs(a.x - b.x) + abs(a.y - b.y)
        end
    end

    defmodule Map do
        defstruct rows: [], obstacles: [], guard: %{ pos: nil, direction: %{ dx: 0, dy: -1} }

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

            guard = %{pos: hd(guard_pos), direction: %{dx: 0, dy: -1}}

            %Map{rows: rows, obstacles: obstacles, guard: guard}
        end

        def guard_routine(%Map{} = map) do
            visited = MapSet.new([])
            {:exit, visited} = walk_guard(map, visited)
            visited
        end

        def show_guard_routine(%Map{} = map) do
            visited = guard_routine(map)
            map_string(map, visited)
        end

        defp map_string(%Map{} = map, visited) do
                        # Create the map as a string, replace the . with a X where the guard has been
                        rows = for {row, y} <- Enum.with_index(map.rows) do
                            for {cell, x} <- Enum.with_index(row) do
                                if MapSet.member?(visited, %Coord{x: x, y: y}) do
                                    "X"
                                else
                                    cell
                                end
                            end
                            |> Enum.join()
                        end
                        Enum.join(rows, "\n")
        end

        defp walk_guard(%Map{rows: rows, guard: %{pos: pos, direction: direction}, obstacles: obstacles} = map, visited) do
            # Check if the guard would leave the map
            if direction.dy == 1 and pos.y == length(rows) - 1 or
               direction.dy == -1 and pos.y == 0 or
               direction.dx == 1 and pos.x == length(hd(rows)) - 1 or
               direction.dx == -1 and pos.x == 0 do
                # IO.puts("debug: would go out at #{inspect(%Coord{x: pos.x + direction.dx, y: direction.dy + pos.y})}")
                visited = MapSet.put(visited, pos)
                {:exit, visited}
            else
                # Calculate next position
                next_pos = %Coord{
                    x: pos.x + direction.dx,
                    y: pos.y + direction.dy
                }

                # Add current position to visited set
                new_visited = MapSet.put(visited, pos)

                # Check if next position has an obstacle
                if Enum.any?(obstacles, fn obstacle -> obstacle == next_pos end) do
                    # Turn right 90 degrees
                    new_direction = %{
                        dx: -direction.dy,  # Turn right: (x,y) -> (y,-x)
                        dy: direction.dx
                    }

                    # Continue with new direction
                    # IO.puts("debug: turning right from #{inspect(pos)} to #{inspect(new_direction)}")
                    new_map = %{map | guard: %{pos: pos, direction: new_direction}}
                    walk_guard(new_map, new_visited)
                else
                    # Continue walking in same direction
                    # IO.puts("debug: going on from #{inspect(pos)} to #{inspect(next_pos)}")
                    new_map = %{map | guard: %{pos: next_pos, direction: direction}}
                    walk_guard(new_map, new_visited)
                end
            end
        end
    end


    def part_one(input_file) do
        input_file
        |> File.stream!()
        |> Map.populate()
        |> Map.guard_routine()
        |> MapSet.size()
    end

    def main(_a) do
        input_file = "lib/day06/input.txt"
        IO.puts("Part one: #{part_one(input_file)}")
    end
end
