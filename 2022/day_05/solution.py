import io
import re
from dataclasses import dataclass

import pandas as pd
from aocd import get_data

from day_05.crane import CrateMover9000, CrateMover9001

CONTAINER_SIZE = 3


@dataclass(frozen=True)
class Movement(object):
    amount: int
    source_pile: int
    target_pile: int

    def __str__(self):
        return f"Move {self.amount} from {self.source_pile} to {self.target_pile}"


def print_containers(stacks: list):
    printable_stacks = stacks[:]
    max_size = max([len(s) for s in printable_stacks])
    for si, pi in enumerate(printable_stacks):
        if len(stacks) < max_size:
            pi.extend(['[ ]'] * (max_size - len(pi)))
        print("{}: {}".format(si, pi))


if __name__ == '__main__':
    input_data = get_data(day=5, year=2022, block=True)
    input_data = input_data.split("\n\n")

    piles = input_data[0]
    movements_raw = input_data[1].split("\n")

    # pre-process piles and insert comma as separator
    matches = re.findall(r'\d+', piles.splitlines()[-1])
    number_of_piles = int(matches[-1])

    new_piles = []
    for p in piles.split('\n'):
        i = 0
        last_pos = 0
        while i < number_of_piles - 1:
            comma_pos = last_pos + CONTAINER_SIZE
            p = p[:comma_pos] + ',' + p[comma_pos:]
            i += 1
            last_pos = comma_pos + 2
        new_piles.append(p)

    new_piles = new_piles[:-1]
    piles_df = pd.read_csv(io.StringIO('\n'.join(new_piles)), sep=",", header=None)

    # read piles
    piles = []
    for _, container in piles_df.items():
        pile = [c.strip() for c in list(container)]
        pile.reverse()
        pile = list(filter(lambda x: x != '', pile))
        piles.append(pile)

    # read movements
    move_re = re.compile(r"move (\d+) from (\d+) to (\d+)")
    movements = []
    for m in movements_raw:
        amount, source, destination = re.findall(move_re, m)[0]
        movements.append(Movement(int(amount), int(source) - 1, int(destination) - 1))

    # create cranes
    crane_9000 = CrateMover9000(piles)
    crane_9001 = CrateMover9001(piles)

    print("before moving:")
    # execute movements
    for m in movements:
        print("Move {} from {} to {}".format(m.amount, m.source_pile, m.target_pile))
        crane_9001.move(m.amount, m.source_pile, m.target_pile)
        crane_9000.move(m.amount, m.source_pile, m.target_pile)

    print("Crane 9000: {}".format(crane_9000.top_most_containers()))
    print("Crane 9001: {}".format(crane_9001.top_most_containers()))
