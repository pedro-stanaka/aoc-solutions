from dataclasses import dataclass

import aocd


@dataclass(frozen=True)
class Packet(object):
    raw: str
    packet_start: int
    message_start: int

    def __str__(self):
        return f"packet_start: {self.packet_start}, message_start: {self.message_start}, raw: {self.raw}"


class ElfCommunicatorProtocol(object):
    @staticmethod
    def __find_marker(data: str, n_distinct: int) -> int:
        """Find marker in streamed data from device."""
        for i in range(len(data)):
            if len(set(data[i : i + n_distinct])) == n_distinct:
                return i + n_distinct

    def __find_message_start(self, data: str):
        return self.__find_marker(data, 14)

    def __find_packet_start(self, data: str):
        return self.__find_marker(data, 4)

    def process(self, data) -> Packet:
        message_start = self.__find_message_start(data)
        packet_start = self.__find_packet_start(data)
        return Packet(data, packet_start, message_start)


if __name__ == "__main__":
    input_data = aocd.get_data(day=6, year=2022, block=True)
    protocol = ElfCommunicatorProtocol()
    packet = protocol.process(input_data)

    print("Part 1: {}".format(packet.packet_start))
    print("Part 2: {}".format(packet.message_start))
