from aocd import get_data


def item_priority(item: str):
    if len(item) > 1:
        return None
    if 97 <= ord(item) <= 122:
        return ord(item) - 96
    else:
        return ord(item) - 38


def calculate_priority(data: list):
    priority_sum = 0
    for rucksack_compartments in data:
        intersection = set(rucksack_compartments[0]).intersection(
            set(rucksack_compartments[1])
        )
        for item in intersection:
            priority_sum += item_priority(item)
    return priority_sum


if __name__ == "__main__":
    input_data = get_data(day=3, year=2022, block=True)

    input_data = input_data.split("\n")
    input_data = [(e[: len(e) // 2], e[len(e) // 2 :]) for e in input_data]

    print("Part 1: {}".format(calculate_priority(input_data)))
