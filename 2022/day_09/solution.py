from __future__ import annotations

import aocd
import numpy as np

D_LEFT = "L"
D_RIGHT = "R"
D_UP = "U"
D_DOWN = "D"


class Knot(object):
    x = 0
    y = 0
    visited = []

    def __init__(self):
        self.x = 0
        self.y = 0
        self.visited.append((self.x, self.y))

    def move(self, direction: str):
        if direction == D_RIGHT:
            self.x += 1
        elif direction == D_UP:
            self.y += 1
        elif direction == D_LEFT:
            self.x -= 1
        elif direction == D_DOWN:
            self.y -= 1
        # self.visited.append((self.x, self.y))

    def move_close(self, other: Knot):
        """move this Knot close to the other, so it is adjacent to it."""
        if self.__is_adjacent(other):
            return

        if self.y == other.y:
            if self.x < other.x:
                self.move(D_RIGHT)
            else:
                self.move(D_LEFT)
        elif self.x == other.x:
            if self.y < other.y:
                self.move(D_UP)
            else:
                self.move(D_DOWN)
        else:  # x and y are different
            if abs(self.y - other.y) > 1:
                # move diagonally up/down
                if self.x < other.x:
                    self.move(D_RIGHT)
                else:
                    self.move(D_LEFT)
                if self.y < other.y:
                    self.move(D_UP)
                else:
                    self.move(D_DOWN)
            else:
                # move diagonally left/right
                if self.y < other.y:
                    self.move(D_UP)
                else:
                    self.move(D_DOWN)
                if self.x < other.x:
                    self.move(D_RIGHT)
                else:
                    self.move(D_LEFT)

    def visited_unique(self):
        return len(set(self.visited))

    def __is_adjacent(self, other: Knot):
        # is above/below
        if self.x == other.x and abs(self.y - other.y) == 1:
            return True
        # is besides
        if self.y == other.y and abs(self.x - other.x) == 1:
            return True
        # overlapping
        if self.x == other.x and self.y == other.y:
            return True
        # diagonally adjacent
        if abs(self.x - other.x) == 1 and abs(self.y - other.y) == 1:
            return True
        return False

    def mark_visited(self):
        self.visited.append((self.x, self.y))


def two_knot_simulation(head: Knot, tail: Knot, cmds: list[str]) -> int:
    for cmd in cmds:
        direction, distance = cmd.split(" ")
        distance = int(distance)
        for i in range(distance):
            head.move(direction)
            tail.move_close(head)
            tail.mark_visited()

    return tail.visited_unique()


EXAMPLE = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2"""

if __name__ == "__main__":
    input_data = aocd.get_data(day=9, year=2022, block=True)

    # input_data = EXAMPLE
    commands = input_data.splitlines()
    head = Knot()
    tail = Knot()
    print(
        "Part 1: places visited at least once: {}".format(
            two_knot_simulation(head, tail, commands)
        )
    )

    # Part 2: ten knots
    head = Knot()
    other_knots = [Knot() for _ in range(9)]
    for cmd in commands:
        direction, distance = cmd.split(" ")
        distance = int(distance)
        for i in range(distance):
            head.move(direction)
            other_knots[0].move_close(head)
            other_knots[0].mark_visited()
            for i in range(1, len(other_knots)):
                other_knots[i].move_close(other_knots[i - 1])
        for knot in other_knots:
            knot.mark_visited()

    print(
        "Part 2: places visited at least once: {}".format(
            other_knots[-1].visited_unique()
        )
    )
