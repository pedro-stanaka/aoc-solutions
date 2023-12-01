import aocd
import matplotlib.pyplot as plt
import numpy as np

EXAMPLE = """498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9"""

if __name__ == '__main__':
    # input_data = aocd.get_data(day=14, year=2022)
    input_data = EXAMPLE
    prev = None

    occupied = set()

    max_y = 0
    for line in input_data.splitlines():
        line = line.split(" -> ")
        x1 = None
        y1 = None
        x = []
        y = []
        prev = None
        for point in line:
            point = point.split(",")
            x.append(int(point[0]))
            y.append(int(point[1]))
            x2 = int(point[0])
            y2 = int(point[1])
            if y2 > max_y:
                max_y = y2
            if x1 is not None:
                if x1 != x2:
                    occupied.update([(x, y1) for x in range(min(x1, x2), max(x1, x2) + 1)])
                else:
                    occupied.update([(x1, y) for y in range(min(y1, y2), max(y1, y2) + 1)])
            x1 = x2
            y1 = y2
        plt.plot(x, y, marker='o')

    SAND_SOURCE = (500, 0)
    iteration = 0
    limit = max_y + 2
    while True:
        iteration += 1
        if iteration > 3:
            break
        cx, cy = SAND_SOURCE
        print(f"Iteration: {iteration}")
        dirty = True
        while dirty:
            dirty = False
            if (cx, cy + 1) not in occupied and cy + 1 != limit:
                cy += 1
                dirty = True
            elif (cx - 1, cy + 1) not in occupied and cy + 1 != limit:
                cy += 1
                cx -= 1
                dirty = True
            elif (cx + 1, cy + 1) not in occupied and cy + 1 != limit:
                cy += 1
                cx += 1
                dirty = True
            elif (cx + 1, cy) not in occupied:
                cx += 1
                dirty = True
            else:
                # print("Done")
                # print(cx, cy)
                dirty = False
            print(f"sand: {cx}, {cy}")
        occupied.add((cx, cy))
        plt.plot(cx, cy, marker='o', color='red')
        if cy == max_y + 1:
            break

    plt.plot(500, 0, color='black', marker='X')
    plt.ylabel('rock path and sand')
    plt.show()
