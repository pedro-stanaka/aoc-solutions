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
    compartments = [(e[: len(e) // 2], e[len(e) // 2:]) for e in input_data]

    i = 0
    badges_sum = 0
    while i < len(input_data):
        inter_group = set(input_data[i]).intersection(set(input_data[i + 1])).intersection(set(input_data[i + 2]))
        if len(inter_group) == 1:
            badges_sum += item_priority(inter_group.pop())
        i += 3

    print("Part 1: {}".format(calculate_priority(compartments)))
    print("Part 2: {}".format(badges_sum))
