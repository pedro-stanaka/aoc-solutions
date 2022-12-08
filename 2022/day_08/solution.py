import aocd
import numpy as np

EXAMPLE = """30373
25512
65332
33549
35390"""


def is_visible(grid: np.array, r: int, c: int) -> bool:
    """Count the number of visible trees in a grid."""
    # check if it is in the border
    if r == 0 or r == grid.shape[0] - 1 or c == 0 or c == grid.shape[1] - 1:
        return True

    # check neighbor trees downwards
    tree_height = grid[r, c]
    all_shorter_down = True
    for i in range(r + 1, grid.shape[0]):
        cur_tree_height = grid[i, c]
        if cur_tree_height >= tree_height:
            all_shorter_down = False
            break
    if all_shorter_down:
        return True

    # go up
    all_shorter_up = True
    i = r - 1
    while i >= 0:
        cur_tree_height = grid[i, c]
        if cur_tree_height >= tree_height:
            all_shorter_up = False
            break
        i -= 1
    if all_shorter_up:
        return True

    # go left
    i = c - 1
    all_shorter_left = True
    while i >= 0:
        cur_tree_height = grid[r, i]
        if cur_tree_height >= tree_height:
            all_shorter_left = False
            break
        i -= 1
    if all_shorter_left:
        return True

    # go right
    all_shorter_right = True
    for i in range(c + 1, grid.shape[1]):
        cur_tree_height = grid[r, i]
        if cur_tree_height >= tree_height:
            all_shorter_right = False
            break
    if all_shorter_right:
        return True

    return False


def scenic_score(grid: np.array, r: int, c: int) -> int:
    # if is at edge, return 0
    if r == 0 or r == grid.shape[0] - 1 or c == 0 or c == grid.shape[1] - 1:
        return 0

    visible_trees_down = 0
    tree_height = grid[r, c]
    for i in range(r + 1, grid.shape[0]):
        visible_trees_down += 1
        if grid[i, c] >= tree_height:
            break

    visible_trees_up = 0
    for i in range(r - 1, -1, -1):
        visible_trees_up += 1
        if grid[i, c] >= tree_height:
            break

    visible_trees_right = 0
    for i in range(c + 1, grid.shape[1]):
        visible_trees_right += 1
        if grid[r, i] >= tree_height:
            break

    visible_trees_left = 0
    for i in range(c - 1, -1, -1):
        visible_trees_left += 1
        if grid[r, i] >= tree_height:
            break

    return visible_trees_down * visible_trees_up * visible_trees_left * visible_trees_right


if __name__ == "__main__":
    input_data = aocd.get_data(day=8, year=2022, block=True)

    # input_data = EXAMPLE
    input_data = input_data.splitlines()
    tree_grid = []
    for x in input_data:
        tree_row = [int(i) for i in list(x)]
        tree_grid.append(tree_row)

    tree_grid = np.array(tree_grid)
    # print(tree_grid)

    n_visible = 0
    for row in range(tree_grid.shape[0]):
        for col in range(tree_grid.shape[1]):
            if is_visible(tree_grid, row, col):
                n_visible += 1
                # print(f"({row}, {col}) is visible. Value: {tree_grid[row, col]}")

    print(f"Part 1: {n_visible} visible trees")

    # Part 2
    max_scenic_score = 0
    max_scenic_coords = (0, 0)
    for row in range(tree_grid.shape[0]):
        for col in range(tree_grid.shape[1]):
            cur_score = scenic_score(tree_grid, row, col)
            # print(f"({row}, {col}) has a scenic score of {cur_score}. Value: {tree_grid[row, col]}")
            if cur_score >= max_scenic_score:
                max_scenic_score = cur_score
                max_scenic_coords = (row, col)

    print(f"Part 2: Max scenic score is {max_scenic_score} at {max_scenic_coords}")
