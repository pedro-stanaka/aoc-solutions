#!/bin/env python
import heapq

from aocd import get_data


def get_elves_snacks_calories(data: str):
    elves_str_list = [e.split("\n") for e in (data.split("\n\n"))]
    return [sum(list(map(lambda s: int(s), e))) for e in elves_str_list]


def get_top_elf_calories(n: int, calories: list):
    return sum(heapq.nlargest(n, calories))


if __name__ == '__main__':
    input_data = get_data(day=1, year=2022, block=True)
    snack_calories = get_elves_snacks_calories(input_data)

    print("Part 2: {}".format(get_top_elf_calories(1, snack_calories)))
    print("Part 1: {}".format(get_top_elf_calories(3, snack_calories)))



