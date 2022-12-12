import math
from copy import deepcopy

import aocd

BOREDOM_CHILL_FACTOR = 3


class ThrowToTest(object):
    def __init__(self, divisible: int, to_true: int, to_false: int):
        self.divisible = divisible
        self.to_true = to_true
        self.to_false = to_false

    def do(self, value: int) -> int:
        if value % self.divisible == 0:
            return self.to_true
        else:
            return self.to_false

    def __repr__(self):
        return f"ThrowToTest(is_divisible: {self.divisible}, true: {self.to_true}, false: {self.to_false})"


class Operation(object):
    MULT = "*"
    ADD = "+"

    def __init__(self, expr: str):
        self.expr = expr

    def do(self, old: int) -> int:
        return eval(self.expr)


class Monkey(object):
    def __init__(
        self, index: int, items: list[int], test: ThrowToTest, operation: Operation
    ):
        self.operation = operation
        self.index = index
        self.items = items
        self.test = test
        self.inspect_count = 0

    def inspect(self, item: int) -> int:
        self.inspect_count += 1
        return int(self.operation.do(item) / BOREDOM_CHILL_FACTOR)

    def inspect_2nd(self, item: int, divisor: int) -> int:
        self.inspect_count += 1
        item = int(self.operation.do(item))
        return item % divisor

    def take(self, item: int):
        self.items.append(item)

    def __repr__(self):
        return f"Monkey({self.index}, {self.items}, {self.test})"

    @staticmethod
    def create_from_string(data: str):
        data = data.splitlines()
        index = int(data[0].split(" ")[-1][:-1])

        operation = " ".join(data[2].split()[-3:])
        op = Operation(operation)

        items = data[1].split(":")[-1].split(",")
        items = [int(e) for e in items]

        divisible_test = int(data[3].split(" ")[-1])
        case_true = int(data[4].split(" ")[-1])
        case_false = int(data[5].split(" ")[-1])
        test = ThrowToTest(divisible_test, case_true, case_false)

        return Monkey(index, items, test, op)


EXAMPLE = """Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1"""

if __name__ == "__main__":
    input_data = aocd.get_data(day=11, year=2022)
    # input_data = EXAMPLE
    input_data = input_data.split("\n\n")

    monkeys = []
    for m in input_data:
        monkeys.append(Monkey.create_from_string(m))

    iterations = 20
    for i in range(iterations):
        for monkey in monkeys:
            if monkey.items:
                for _ in range(len(monkey.items)):
                    item = monkey.items.pop(0)
                    # print(f"Monkey {monkey.index}: inspect an item with level {item}.")
                    # item = monkey.inspect_2nd(item, divisor=product_terms)
                    item = monkey.inspect(item)
                    # print(f"New level is: {item}. Test: {monkey.test}")
                    dest_monkey = monkey.test.do(item)
                    monkeys[dest_monkey].take(item)

    monkeys.sort(key=lambda x: x.inspect_count, reverse=True)

    for i in range(2):
        print(f"Monkey {monkeys[i].index}: {monkeys[i].inspect_count}")

    print(
        f"Activity level (pt 1): {monkeys[0].inspect_count * monkeys[1].inspect_count}"
    )

    # Part 2
    print("#################")
    print("Part 2")
    monkeys = []
    for m in input_data:
        monkeys.append(Monkey.create_from_string(m))

    product_terms = math.prod([m.test.divisible for m in monkeys])
    iterations = 10_000
    for i in range(iterations):
        for monkey in monkeys:
            if monkey.items:
                for _ in range(len(monkey.items)):
                    item = monkey.items.pop(0)
                    # print(f"Monkey {monkey.index}: inspect an item with level {item}.")
                    item = monkey.inspect_2nd(item, divisor=product_terms)
                    # print(f"New level is: {item}. Test: {monkey.test}")
                    dest_monkey = monkey.test.do(item)
                    monkeys[dest_monkey].take(item)

    monkeys.sort(key=lambda x: x.inspect_count, reverse=True)
    print(
        f"Activity level (pt 2): {monkeys[0].inspect_count * monkeys[1].inspect_count}"
    )
