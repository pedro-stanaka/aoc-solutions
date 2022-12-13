import json
from copy import deepcopy
from itertools import zip_longest

import aocd
import numpy as np

EXAMPLE = """[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"""

CONTINUE = 0
WRONG_ORDER = 1
RIGHT_ORDER = 2

def compare(left, right):
    if isinstance(left, int) and isinstance(right, int):
        if left == right:
            return CONTINUE
        elif left < right:
            return RIGHT_ORDER
        else:
            return WRONG_ORDER

    # check if a and b are lists
    elif isinstance(left, list) and isinstance(right, list):
        for l, r in zip_longest(left, right):
            if l is None:
                return RIGHT_ORDER
            elif r is None:
                return WRONG_ORDER

            result = compare(l, r)
            if result != CONTINUE:
                return result

    elif isinstance(left, list) and isinstance(right, int):
        return compare(left, [right])

    elif isinstance(left, int) and isinstance(right, list):
        return compare([left], right)

    return CONTINUE


if __name__ == '__main__':
    input_data = aocd.get_data(day=13, year=2022)
    # input_data = EXAMPLE

    input_data = input_data.split("\n\n")

    packet_pairs = []
    for ln in input_data:
        first = ln.split("\n")[0]
        second = ln.split("\n")[1]

        first = json.loads(first)
        second = json.loads(second)
        packet_pairs.append((first, second))

    right_order = []
    for pix, packet in enumerate(packet_pairs):
        if compare(packet[0], packet[1]) == RIGHT_ORDER:
            right_order.append(pix + 1)

    print(f"Right order: {sum(right_order)}")
