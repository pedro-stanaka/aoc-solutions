defmodule WordMatrix do
  defstruct rows: []

  @doc """
  Populate the matrix from a list of strings.

  ## Examples

      iex> WordMatrix.populate([
      ...>   "MMMSXXMASM",
      ...>   "MSAMXMSMSA",
      ...>   "AMXSXMAAMM",
      ...> ])
  """
  def populate(lines) do
    lines
    |> Enum.map(&String.graphemes/1)
    |> then(&struct(WordMatrix, rows: &1))
  end

  @doc """
  Search for a word in the matrix in all directions (horizontal, vertical, diagonal)
  and in both forward and reverse order.
  Returns the count of occurrences.

  ## Examples

      iex> matrix = WordMatrix.populate([
      ...>   "MMMSXXMASM",
      ...>   "MSAMXMSMSA",
      ...>   "AMXSXMAAMM",
      ...>   "MSAMASMSMX",
      ...>   "XMASAMXAMM",
      ...>   "XXAMMXXAMA",
      ...>   "SMSMSASXSS",
      ...>   "SAXAMASAAA",
      ...>   "MAMMMXMMMM",
      ...>   "MXMXAXMASX"
      ...> ])
      iex> WordMatrix.search(matrix, "XMAS")
      18
  """
  def search(%WordMatrix{rows: rows}, word) do
    height = length(rows)
    width = length(hd(rows))

    # Generate all possible starting positions
    for row <- 0..(height-1),
        col <- 0..(width-1),
        direction <- [{0,1}, {1,0}, {1,1}, {-1,1}], # Right, Down, Diag Down-Right, Diag Up-Right
        check_word_at_position(rows, row, col, word, direction) or
        check_word_at_position(rows, row, col, String.reverse(word), direction),
        reduce: 0 do
      acc -> acc + 1
    end
  end

  @doc """
  Search for the word "MAS" in a format of an X in the matrix.
  The word can be written backwards as well.
  Example of the pattern:

      M.S
      .A.
      M.S

  ## Examples

      iex> matrix = WordMatrix.populate([
      ...>   "MMMSXXMASM",
      ...>   "MSAMXMSMSA",
      ...>   "AMXSXMAAMM",
      ...>   "MSAMASMSMX",
      ...>   "XMASAMXAMM",
      ...>   "XXAMMXXAMA",
      ...>   "SMSMSASXSS",
      ...>   "SAXAMASAAA",
      ...>   "MAMMMXMMMM",
      ...>   "MXMXAXMASX"
      ...> ])
      iex> WordMatrix.search_x_mas(matrix)
      9

  """
  def search_x_mas(%WordMatrix{rows: rows}) do
    height = length(rows)
    width = length(hd(rows))

    # For each possible center position
    for row <- 1..(height-2),
        col <- 1..(width-2),
        reduce: 0 do
      acc -> count_x_mas_at_position(rows, row, col, acc)
    end
  end

  defp count_x_mas_at_position(rows, row, col, acc) do
    with "A" <- get_cell(rows, row, col),
         corners <- get_corners(rows, row, col),
         true <- valid_x_pattern?(corners) do
      acc + 1
    else
      _ -> acc
    end
  end

  defp get_cell(rows, row, col) do
    rows |> Enum.at(row) |> Enum.at(col)
  end

  defp get_corners(rows, row, col) do
    %{
      top_left: get_cell(rows, row-1, col-1),
      top_right: get_cell(rows, row-1, col+1),
      bottom_left: get_cell(rows, row+1, col-1),
      bottom_right: get_cell(rows, row+1, col+1)
    }
  end

  defp valid_x_pattern?(corners) do
    valid_diagonal?(corners.top_left, corners.bottom_right) and
    valid_diagonal?(corners.top_right, corners.bottom_left)
  end

  defp valid_diagonal?(start, finish) do
    (start == "M" and finish == "S") or (start == "S" and finish == "M")
  end

  defp check_word_at_position(rows, row, col, word, {dy, dx}) do
    word_length = String.length(word)
    height = length(rows)
    width = length(hd(rows))

    # Check if word would go out of bounds
    end_row = row + (word_length - 1) * dy
    end_col = col + (word_length - 1) * dx

    if end_row >= 0 and end_row < height and end_col >= 0 and end_col < width do
      # Get characters along direction
      chars = for i <- 0..(word_length-1) do
        rows
        |> Enum.at(row + i * dy)
        |> Enum.at(col + i * dx)
      end
      |> Enum.join()

      chars == word
    else
      false
    end
  end
end
