from unittest import TestCase

from day_13.solution import RIGHT_ORDER, WRONG_ORDER, compare


class Test(TestCase):
    def test_compare(self):
        cases = [
            {
                "name": "equal lists",
                "left": [1, 4, 5],
                "right": [1, 4, 5],
                "result": 0,
            },
            {
                "name": "left shorter",
                "left": [1, 4, 5],
                "right": [1, 4, 5, 6],
                "result": RIGHT_ORDER,
            },
            {
                "name": "right shorter",
                "left": [1, 4, 5],
                "right": [1, 4],
                "result": WRONG_ORDER,
            },
            {
                "name": "mismatch types",
                "left": 9,
                "right": [[8, 7, 6]],
                "result": WRONG_ORDER,
            },
            {
                "name": "deep nested",
                "left": [[4, 4], 4, 4],
                "right": [[4, 4], 4, 4, 4],
                "result": RIGHT_ORDER,
            }
        ]

        for case in cases:
            with self.subTest(msg=case["name"]):
                result = compare(case["left"], case["right"])
                self.assertEqual(result, case["result"])
