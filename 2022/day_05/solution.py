import io
import re
from dataclasses import dataclass

import pandas as pd
from aocd import get_data

CONTAINER_SIZE = 3


@dataclass(frozen=True)
class Movement(object):
    amount: int
    source_pile: int
    target_pile: int

    def __str__(self):
        return f"Move {self.amount} from {self.source_pile} to {self.target_pile}"

# def pretty_print(piles: list):
#     # print columns
#     max_size = max([len(pile) for pile in piles])
#     printable_piles = []
#     for p in piles:
#         if len(p) < max_size:
#             p.extend([' '] * (max_size - len(p)))
#         printable_piles.append(p)
#
#     pile_mt = np.matrix(printable_piles)
#     pile_mt = pd.DataFrame(pile_mt)
#     print(pile_mt.transpose().iloc[::-1])


def print_lines(pp: list):
    n_piles = pp[:]
    max_size = max([len(pile) for pile in n_piles])
    for i, pi in enumerate(n_piles):
        if len(pp) < max_size:
            pi.extend(['[ ]'] * (max_size - len(pi)))
        print("{}: {}".format(i, pi))


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

    # read movements
    move_re = re.compile(r"move (\d+) from (\d+) to (\d+)")
    movements = []
    for m in movements_raw:
        amount, source, destination = re.findall(move_re, m)[0]
        movements.append(Movement(int(amount), int(source) - 1, int(destination) - 1))

    # read piles
    piles = []
    for _, container in piles_df.items():
        pile = [c.strip() for c in list(container)]
        pile.reverse()
        pile = list(filter(lambda x: x != '', pile))
        piles.append(pile)
    print_lines(piles)

    # execute movements
    for m in movements:
        for _ in range(m.amount):
            el = piles[m.source_pile].pop()
            piles[m.target_pile].append(el)

    # print top lines
    top_lines = []
    for i, p in enumerate(piles):
        print("Pile {}: {}".format(i + 1, p[-1]))
        top_lines.append(p[-1])

    new = list(map(lambda x: x.lstrip('[').rstrip(']'), top_lines))
    print(''.join(new))
