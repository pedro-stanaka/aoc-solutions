from unittest import TestCase

from day_06.solution import ElfCommunicatorProtocol


class TestElfCommunicatorProtocol(TestCase):
    def test_process(self):
        cases = [
            {
                "input": "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
                "packet": 7,
                "message": 19,
            },
            {
                "input": "bvwbjplbgvbhsrlpgdmjqwftvncz",
                "packet": 5,
                "message": 23,
            },
            {
                "input": "nppdvjthqldpwncqszvftbrmjlhg",
                "packet": 6,
                "message": 23,
            },
            {
                "input": "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
                "packet": 10,
                "message": 29,
            },
        ]

        protocol = ElfCommunicatorProtocol()
        for case in cases:
            with self.subTest(msg=case["input"]):
                packet = protocol.process(case["input"])
                self.assertEqual(packet.packet_start, case["packet"])
                self.assertEqual(packet.message_start, case["message"])
