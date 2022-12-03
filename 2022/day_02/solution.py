from aocd import get_data

SCORE_COMBINATIONS = {
    "AX": 3,
    "AY": 6,
    "AZ": 0,
    "BX": 0,
    "BY": 3,
    "BZ": 6,
    "CX": 6,
    "CY": 0,
    "CZ": 3,
}

HAND_WEIGHTS = {"A": 1, "B": 2, "C": 3, "X": 1, "Y": 2, "Z": 3}


def calculate_score(data: list):
    final_score = 0
    for e in data:
        final_score += SCORE_COMBINATIONS[e[0] + e[1]] + HAND_WEIGHTS[e[1]]
    return final_score


# A= Rock, B= Paper, C= Scissors
# X = rock
# Y = paper
# Z = scissors

# X = lose
# Y = draw
# Z = win

RESULT_MAPPING = {
    "X": 0,
    "Y": 3,
    "Z": 6,
}

HAND_MAPPING = {
    "AY": 1,
    "BY": 2,
    "CY": 3,
    "AX": 3,
    "BX": 1,
    "CX": 2,
    "AZ": 2,
    "BZ": 3,
    "CZ": 1
}


def guess_hand_and_calculate_score(strategy_book: list):
    final_score = 0
    for e in strategy_book:
        final_score += RESULT_MAPPING[e[1]] + HAND_MAPPING[e[0] + e[1]]
    return final_score


def process_input(data: str):
    data = data.split("\n")
    return [e.split(" ") for e in data]


if __name__ == "__main__":
    input_data = get_data(day=2, year=2022, block=True)
    process_input(input_data)

    print("Part 1: {}".format(calculate_score(input_data)))
    print("Part 2: {}".format(guess_hand_and_calculate_score(input_data)))
