# abstract class Crane
from abc import ABC, abstractmethod
from copy import deepcopy


class Crane(ABC):
    containers = []

    @abstractmethod
    def move(self, n: int, stack_from: int, stack_to: int) -> None:
        pass

    def top_most_containers(self) -> str:
        top_lines = []
        for pi, pile in enumerate(self.containers):
            print("Pile {}: {}".format(pi + 1, pile[-1]))
            top_lines.append(pile[-1])

        top_str = list(map(lambda x: x.lstrip("[").rstrip("]"), top_lines))
        return "".join(top_str)

    def __repr__(self):
        printable_stacks = deepcopy(self.containers)
        max_size = max([len(s) for s in printable_stacks])
        result = ""
        for si, pi in enumerate(printable_stacks):
            if len(pi) < max_size:
                print("changing size")
                pi.extend(["[ ]"] * (max_size - len(pi)))
            result += ("{}: {}".format(si, pi)) + "\n"
        return result


class CrateMover9000(Crane):
    def __init__(self, containers: list):
        self.containers = deepcopy(containers)

    def move(self, n: int, stack_from: int, stack_to: int) -> None:
        """Move {n} crates from one stack to another."""
        for _ in range(n):
            self.containers[stack_to].append(self.containers[stack_from].pop())


class CrateMover9001(Crane):
    def __init__(self, containers: list):
        self.containers = deepcopy(containers)

    def move(self, n: int, stack_from: int, stack_to: int) -> None:
        """Move {n} crates from one stack to another."""
        if n == 1:
            self.containers[stack_to].append(self.containers[stack_from].pop())
        else:
            self.containers[stack_to].extend(self.containers[stack_from][-n:])
            self.containers[stack_from] = self.containers[stack_from][:-n]
