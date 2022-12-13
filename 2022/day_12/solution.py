import aocd
import networkx as nx
import numpy as np

EXAMPLE = """Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi"""


def neighbors(hmp: np.array, mg: nx.DiGraph, i: int, j: int) -> None:
    for x, y in [(i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1)]:
        cur = f"{i}|{j}"
        target = f"{x}|{y}"
        if x < 0 or y < 0 or x >= hmp.shape[0] or y >= hmp.shape[1]:
            continue
        if hmp[x, y] == "S":
            continue
        if mg.has_edge(cur, target):
            continue

        cur_elevation = ord(hmp[i, j])
        if hmp[i, j] == "S":
            cur_elevation = ord("a")
        target_elevation = ord(hmp[x, y])
        if hmp[x, y] == "E":
            target_elevation = ord("z")

        if (
            cur_elevation > target_elevation
            or (
                cur_elevation < target_elevation
                and abs(cur_elevation - target_elevation) <= 1
            )
            or hmp[i, j] == "S"
            or hmp[x, y] == "E"
        ):
            weight = float(abs(cur_elevation - target_elevation))
            weight = max(weight, 1.0)
            print(f"{cur}({hmp[i, j]}) -> {target}({hmp[x, y]}) - weight: {weight}")
            mg.add_edge(cur, target, weight=weight)


if __name__ == "__main__":
    # input_data = aocd.get_data(day=12, year=2022)
    input_data = EXAMPLE
    heightmap = []
    for line in input_data.splitlines():
        heightmap.append([c for c in line])

    heightmap = np.array(heightmap)
    print(heightmap)

    # Find the start and end points
    start = np.where(heightmap == "S")
    start = f"{start[0][0]}|{start[1][0]}"
    end = np.where(heightmap == "E")
    end = f"{end[0][0]}|{end[1][0]}"

    map_graph = nx.DiGraph()

    for i in range(heightmap.shape[0]):
        for j in range(heightmap.shape[1]):
            neighbors(heightmap, map_graph, i, j)

    path = nx.shortest_path(map_graph, source=start, target=end, weight="weight")
    spath_lenght = nx.shortest_path_length(
        map_graph, source=start, target=end, weight="weight"
    )

    path_grid = np.full(heightmap.shape, dtype=str, fill_value=" ")

    # print(map_graph.get_edge_data(start, path[1]))
    print("Solution #######")
    previous = (0, 0)
    prev = ""
    for i, p in enumerate(path):
        x, y = p.split("|")
        path_grid[int(x), int(y)] = heightmap[int(x), int(y)]
        if map_graph.get_edge_data(prev, p):
            print(
                f"{prev}({heightmap[previous[0], previous[1]]}) -> {p}({heightmap[int(x), int(y)]}) - weight: {map_graph.get_edge_data(prev, p)['weight']}"
            )
        previous = (int(x), int(y))
        prev = p
    # print(path)
    print(path_grid)

    paths = nx.shortest_paths.all_shortest_paths(
        map_graph, source=start, target=end, weight="weight"
    )
    for p in paths:
        print(p)

    print("Shortest path length:", spath_lenght)
