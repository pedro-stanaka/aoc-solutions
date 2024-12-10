defmodule Day06 do
    defmodule Coord do
        defstruct x: 0, y: 0

        def distance(a, b) do
            abs(a.x - b.x) + abs(a.y - b.y)
        end
    end

    @moduledoc """
    Represents the map of the problem.
    """
    defmodule Map do
        defstruct rows: [], obstacles: [], guard: %{pos: nil, direction: %{dx: 0, dy: -1}}

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
            visited_states = MapSet.new([])
            {:exit, visited_states} = walk_guard(map, visited_states, check_loops: false)
            # Extract just positions from states
            visited_states
            |> MapSet.to_list()
            |> Enum.map(fn {pos, _dir} -> pos end)
            |> MapSet.new()
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

        defp walk_guard(%Map{} = map, visited_states, opts \\ []) do
            check_loops = Keyword.get(opts, :check_loops, false)
            %{rows: rows, guard: %{pos: pos, direction: direction}} = map

            # Track both position and direction for loop detection
            state = {pos, direction}

            if check_loops and MapSet.member?(visited_states, state) do
                {:loop, visited_states}
            else
                visited_states = MapSet.put(visited_states, state)
                cond do
                    would_leave_map?(pos, direction, rows) ->
                        {:exit, visited_states}

                    would_hit_obstacle?(map, pos, direction) ->
                        # Turn right and continue
                        map
                        |> turn_guard_right()
                        |> walk_guard(visited_states, opts)

                    true ->
                        # Move forward
                        map
                        |> move_guard_forward()
                        |> walk_guard(visited_states, opts)
                end
            end
        end

        defp would_leave_map?(pos, direction, rows) do
            direction.dy == 1 and pos.y == length(rows) - 1 or
            direction.dy == -1 and pos.y == 0 or
            direction.dx == 1 and pos.x == length(hd(rows)) - 1 or
            direction.dx == -1 and pos.x == 0
        end

        defp would_hit_obstacle?(%Map{obstacles: obstacles}, pos, direction) do
            next_pos = %Coord{
                x: pos.x + direction.dx,
                y: pos.y + direction.dy
            }
            Enum.any?(obstacles, fn obstacle -> obstacle == next_pos end)
        end

        defp turn_guard_right(%Map{guard: %{pos: pos, direction: direction}} = map) do
            new_direction = %{
                dx: -direction.dy,  # Turn right: (x,y) -> (y,-x)
                dy: direction.dx
            }
            %{map | guard: %{pos: pos, direction: new_direction}}
        end

        defp move_guard_forward(%Map{guard: %{pos: pos, direction: direction}} = map) do
            next_pos = %Coord{
                x: pos.x + direction.dx,
                y: pos.y + direction.dy
            }
            %{map | guard: %{pos: next_pos, direction: direction}}
        end

        def find_loop_positions(%Map{} = map) do
            empty_positions = for {row, y} <- Enum.with_index(map.rows),
                                {cell, x} <- Enum.with_index(row),
                                cell == ".",
                                %Coord{x: x, y: y} != map.guard.pos,
                                do: %Coord{x: x, y: y}

            # Process positions in parallel using Task.async_stream
            empty_positions
            |> Task.async_stream(
                fn pos -> {pos, creates_loop?(map, pos)} end,
                max_concurrency: System.schedulers_online() * 2
            )
            |> Stream.filter(fn {:ok, {_pos, creates_loop?}} -> creates_loop? end)
            |> Enum.map(fn {:ok, {pos, _}} -> pos end)
        end

        defp creates_loop?(%Map{} = map, pos) do
            # Add the test obstacle to the map
            map_with_obstacle = %{map | obstacles: [pos | map.obstacles]}

            # Try walking the guard's path with loop checking enabled
            visited_states = MapSet.new()
            case walk_guard(map_with_obstacle, visited_states, check_loops: true) do
                {:loop, _} -> true
                _ -> false
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

    def part_two(input_file) do
        input_file
        |> File.stream!()
        |> Map.populate()
        |> Map.find_loop_positions()
        |> length()
    end

    def main(_a) do
        input_file = "lib/day06/input.txt"
        IO.puts("Part one: #{part_one(input_file)}")
        IO.puts("Part two: #{part_two(input_file)}")
    end
end
