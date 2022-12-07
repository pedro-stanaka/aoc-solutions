import re

import anytree
import aocd
from anytree import Node, RenderTree, Resolver, ChildResolverError


def is_command(line: str) -> bool:
    """Check if a line is a command."""
    return line.startswith("$")


def is_ls(line):
    """Check if a line is a ls command."""
    return line.startswith("$ ls")


def is_chdir(line: str) -> bool:
    """Check if a line is a chdir command."""
    return line.startswith("$ cd")


def is_going_up(line: str) -> bool:
    """Check if a line is a going up command."""
    return line.startswith("$ cd ..")


def read_dir(lines: list[str], current: Node) -> int:
    """Read a directory from a list of lines."""
    cnt = 0
    for line in lines:
        if is_command(line) and not is_ls(line):
            return cnt

        if is_ls(line):
            continue
        else:
            if line.startswith("dir"):
                Node(line.split()[-1], parent=current)
            else:
                Node(line.split()[1], parent=current, size=int(line.split()[0]))
        cnt += 1

    return cnt


def calculate_size(node: Node):
    if node.is_leaf:
        return node.size
    else:
        node.size = sum([calculate_size(child) for child in node.children])
        return node.size


if __name__ == "__main__":
    input_data = aocd.get_data(day=7, year=2022, block=True)
    dir_tree = None
    reading_dir = False
    cur_dir = None

    input_data = input_data.splitlines()

    r = Resolver("name")
    i = 0
    while i < len(input_data):
        if is_command(input_data[i]):
            if is_chdir(input_data[i]) and not is_going_up(input_data[i]):
                reading_dir = True
                dir_name = input_data[i].split()[-1]
                if dir_name == "/":
                    dir_name = "root"
                if dir_tree is None:
                    dir_tree = Node(dir_name, parent=None, size=0)
                    cur_dir = dir_tree
                else:
                    # get existing dir that we created when reading the subdirs
                    cur_dir = r.get(cur_dir, dir_name)
                read_file_count = read_dir(input_data[i + 1:], cur_dir)
                i += read_file_count + 2
                continue
            if is_going_up(input_data[i]):
                cur_dir = cur_dir.parent
                i += 1
                continue

    used_space = 0
    minimum_unused = 30_000_000
    available_space = 70_000_000
    for node in dir_tree.children:
        calculate_size(node)
        used_space += node.size

    currently_unused = available_space - used_space
    print(f"Currently used: {used_space:,}")
    print(f"Currently unused space: {currently_unused:,}")

    dir_size_to_delete = 0
    if currently_unused < 0:
        dir_size_to_delete = (currently_unused * -1) + minimum_unused
    else:
        dir_size_to_delete = minimum_unused - currently_unused
    print(f"Directory size to exclude: {dir_size_to_delete :,}")

    answer = sum(
        [n.size for n in anytree.findall(dir_tree, filter_=lambda node: node.size < 100_000 and not node.is_leaf)])
    print(f"Day 7, part 1: {answer:,}. Raw: {answer}")

    deletable_dir_sizes = [n.size for n in anytree.findall(dir_tree, filter_=lambda
        node: node.size > dir_size_to_delete and not node.is_leaf)]
    smallest_dir = min(deletable_dir_sizes)
    print(f"Day 7, part 2: {smallest_dir:,}. Raw: {smallest_dir}")
