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


def read_container_piles(container_piles: str) -> list:
    new_piles = []
    # pre-process piles and insert comma as separator
    matches = re.findall(r"\d+", containers_text.splitlines()[-1])
    number_of_piles = int(matches[-1])
    for p in container_piles.splitlines():
        i = 0
        last_pos = 0
        while i < number_of_piles - 1:
            comma_pos = last_pos + CONTAINER_SIZE
            p = p[:comma_pos] + "," + p[comma_pos:]
            i += 1
            last_pos = comma_pos + 2
        new_piles.append(p)
    new_piles = new_piles[:-1]
    piles_df = pd.read_csv(io.StringIO("\n".join(new_piles)), sep=",", header=None)
    # read piles
    container_piles = []
    for _, container in piles_df.items():
        pile = [c.strip() for c in list(container)]
        pile.reverse()
        pile = list(filter(lambda x: x != "", pile))
        container_piles.append(pile)

    return container_piles


if __name__ == "__main__":
    input_data = get_data(day=5, year=2022, block=True)
    input_data = input_data.split("\n\n")

    containers_text = input_data[0]
    movements_text = input_data[1].splitlines()

    containers = read_container_piles(containers_text)

    # read movements
    move_re = re.compile(r"move (\d+) from (\d+) to (\d+)")
    movements = []
    for m in movements_text:
        amount, source, destination = re.findall(move_re, m)[0]
        movements.append(Movement(int(amount), int(source) - 1, int(destination) - 1))

    # create cranes
    crane_9000 = CrateMover9000(containers)
    crane_9001 = CrateMover9001(containers)

    # execute movements
    for m in movements:
        print("Move {} from {} to {}".format(m.amount, m.source_pile, m.target_pile))
        crane_9001.move(m.amount, m.source_pile, m.target_pile)
        crane_9000.move(m.amount, m.source_pile, m.target_pile)

    print("Crane 9000: {}".format(crane_9000.top_most_containers()))
    print("Crane 9001: {}".format(crane_9001.top_most_containers()))
