import math

import aocd
import numpy as np


def signal_strength(cycle, X):
    if cycle in (20, 60, 100, 140, 180, 220):
        return cycle * X
    else:
        return 0


def part_one(data: str):
    cycle = 0
    X = 1
    signals = data.splitlines()
    ss = 0
    for s in signals:
        if s == "noop":
            cycle += 1
            ss += signal_strength(cycle, X)
        elif s.startswith("addx"):
            cycle += 1
            ss += signal_strength(cycle, X)
            V = int(s.split(" ")[-1])
            cycle += 1
            ss += signal_strength(cycle, X)
            X += V
    return ss


def lit_pixels(screen, cycle, X):
    # import pdb;pdb.set_trace()
    pixel_row = math.floor((cycle - 1) / 40)
    pixel_col = (cycle - 1) % 40
    lit = [
        p
        for p in [(pixel_row, X - 1), (pixel_row, X), (pixel_row, X + 1)]
        if pixel_col == p[1]
    ]
    for l in lit:
        m, n = l
        screen[m, n] = "██"
    return screen


def draw_display(screen):
    return "\n".join(["".join([pixel for pixel in row]) for row in screen])


def part_two(data: str):
    cycle = 0
    X = 1
    signals = data.splitlines()
    screen = np.array([["."] * 40] * 6)
    for s in signals:
        if s == "noop":
            cycle += 1
            screen = lit_pixels(screen, cycle, X)
        elif s.startswith("addx"):
            cycle += 1
            screen = lit_pixels(screen, cycle, X)
            V = int(s.split(" ")[-1])
            cycle += 1
            screen = lit_pixels(screen, cycle, X)
            X += V
    return draw_display(screen)


if __name__ == "__main__":
    data = aocd.get_data(day=10, year=2022, block=True)
    print(part_one(data))
    print(part_two(data))
