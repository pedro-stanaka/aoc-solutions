from unittest import TestCase

from day_01.day01 import get_elves_snacks_calories
from day_01.day01 import get_top_elf_calories

TEST_INPUT = """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"""


class Day01Test(TestCase):
    def test_get_elves_snacks_calories(self):
        calories = get_elves_snacks_calories(TEST_INPUT)
        self.assertEqual([6000, 4000, 11_000, 24_000, 10_000], calories)

    def test_get_top_elf_calories(self):
        calories = get_elves_snacks_calories(TEST_INPUT)
        top_elf_calories = get_top_elf_calories(1, calories)
        self.assertEqual(24_000, top_elf_calories)

        top3_cals = get_top_elf_calories(3, calories)
        self.assertEqual(24_000 + 11_000 + 10_000, top3_cals)
