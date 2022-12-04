from aocd import get_data


def is_contained(set1, set2):
    return set1.issubset(set2) or set2.issubset(set1)


if __name__ == "__main__":
    input_data = get_data(day=4, year=2022, block=True)
    input_data = input_data.split("\n")
    input_data = [e.split(",") for e in input_data]

    # create ranges from each pair
    ranges = []
    for e in input_data:
        ranges.append(
            [
                set(range(int(e[0].split("-")[0]), int(e[0].split("-")[1]) + 1)),
                set(range(int(e[1].split("-")[0]), int(e[1].split("-")[1]) + 1)),
            ]
        )

    # count the ranges that overlap
    overlap_count = 0
    inter_count = 0
    for rp in ranges:
        if rp[0].issubset(rp[1]) or rp[1].issubset(rp[0]):
            overlap_count += 1
            print("containment found between {} and {}".format(rp[0], rp[1]))
        if rp[0].intersection(rp[1]) != set():
            inter_count += 1
            print("intersection found between {} and {}".format(rp[0], rp[1]))

    print("Part 1: {}".format(overlap_count))
    print("Part 2: {}".format(inter_count))
