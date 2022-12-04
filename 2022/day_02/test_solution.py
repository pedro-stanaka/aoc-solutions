from unittest import TestCase

from day_02.solution import (
    process_input,
    guess_hand_and_calculate_score,
    calculate_score,
)

SAMPLE_INPUT = """A Y
B X
C Z"""


class Test(TestCase):
    def test_guess_hand_and_calculate_score(self):
        strategy_book = process_input(SAMPLE_INPUT)
        self.assertEqual(12, guess_hand_and_calculate_score(strategy_book))

    def test_calculate_score(self):
        strategy_book = process_input(SAMPLE_INPUT)
        self.assertEqual(15, calculate_score(strategy_book))
