import json
from ast import literal_eval
from functools import cmp_to_key, total_ordering
from itertools import zip_longest, chain
import aocd

CONTINUE = 0
WRONG_ORDER = 1
RIGHT_ORDER = 2


def map_value_to_const(value):
    if value == 0:
        return "CONTINUE"
    elif value == 1:
        return "WRONG_ORDER"
    elif value == 2:
        return "RIGHT_ORDER"
    else:
        return value


@total_ordering
class Packet(object):
    def __init__(self, data: list):
        self.data = data

    def __eq__(self, other):
        return False

    def __lt__(self, other):
        return compare(self.data, other.data) == RIGHT_ORDER

    def __repr__(self):
        return f"{self.data}"


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

if __name__ == "__main__":
    input_data = aocd.get_data(day=13, year=2022)
    # input_data = EXAMPLE

    input_data = input_data.split("\n\n")

    packet_pairs = []
    for ln in input_data:
        first = ln.split("\n")[0]
        second = ln.split("\n")[1]

        first = literal_eval(first)
        second = literal_eval(second)
        packet_pairs.append((first, second))

    right_order = []
    for pix, packet in enumerate(packet_pairs):
        # print(f"Packet {pix}, result: {compare(packet[0], packet[1])}")
        if compare(packet[0], packet[1]) == RIGHT_ORDER:
            right_order.append(pix + 1)

    print(f"Sum of indices in right order: {sum(right_order)}")
    aocd.submit(sum(right_order), day=13, year=2022, part="a")

    packets = list(chain(*packet_pairs))
    packets.extend([[[2]], [[6]]])
    packets = [Packet(p) for p in packets]

    # sort packets
    sorted_packets = sorted(packets)
    pkt_strings = []
    for packet in sorted_packets:
        # print(packet)
        pkt_strings.append(str(packet))

    index_6 = pkt_strings.index("[[6]]") + 1
    index_2 = pkt_strings.index("[[2]]") + 1

    print(
        f"Product of indexes: {index_6 * index_2}. Index of [[6]]: {index_6}, index of [[2]]: {index_2}"
    )
    aocd.submit(index_6 * index_2, day=13, year=2022, part="b")
