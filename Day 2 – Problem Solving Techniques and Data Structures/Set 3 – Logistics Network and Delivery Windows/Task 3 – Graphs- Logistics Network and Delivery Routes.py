from collections import deque
def shortest_route(graph, start, end):
    if start not in graph or end not in graph:
        return []
    queue = deque([[start]])
    visited = {start}
    while queue:
        path = queue.popleft()
        current = path[-1]
        if current == end:
            return path
        for neighbor in graph[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(path + [neighbor])
    return []
def reachable_hubs(graph, start):
    if start not in graph:
        return []
    visited = set()
    result = []
    def dfs(hub):
        visited.add(hub)
        result.append(hub)
        for neighbor in graph[hub]:
            if neighbor not in visited:
                dfs(neighbor)
    dfs(start)
    return result
routes = {
    "H01": ["H02", "H03"],
    "H02": ["H04", "H05"],
    "H03": ["H06"],
    "H04": ["H07"],
    "H05": ["H07"],
    "H06": ["H08"],
    "H07": ["H09"],
    "H08": ["H09"],
    "H09": ["H10"],
    "H10": []
}
print("Adjacency List:")
for hub, connections in routes.items():
    print(f"{hub}: {connections}")
print("Shortest route:", " -> ".join(shortest_route(routes, "H01", "H10")))
print("Reachable hubs from central depot:", reachable_hubs(routes, "H01"))
print("Unreachable destination:", shortest_route(routes, "H01", "H99"))
print("Empty graph:", reachable_hubs({}, "H01"))
