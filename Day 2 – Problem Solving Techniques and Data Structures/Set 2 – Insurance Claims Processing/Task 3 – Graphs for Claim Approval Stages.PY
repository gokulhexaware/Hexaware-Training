from collections import deque
def shortest_path(graph, start, end):
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
def has_cycle(graph):
    visited = set()
    active = set()
    def dfs(node):
        visited.add(node)
        active.add(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                if dfs(neighbor):
                    return True
            elif neighbor in active:
                return True
        active.remove(node)
        return False
    for node in graph:
        if node not in visited:
            if dfs(node):
                return True
    return False
stages = {
    "Registration": ["Assessment"],
    "Assessment": ["Surveyor"],
    "Surveyor": ["Settlement"],
    "Settlement": []
}
print("Shortest approval path:", " -> ".join(shortest_path(stages, "Registration", "Settlement")))
print("Cycle detected:", has_cycle(stages))
cyclic_stages = {
    "Registration": ["Assessment"],
    "Assessment": ["Surveyor"],
    "Surveyor": ["Registration", "Settlement"],
    "Settlement": []
}
print("Cycle in modified graph:", has_cycle(cyclic_stages))
print("Empty graph path:", shortest_path({}, "Registration", "Settlement"))
print("Empty graph cycle:", has_cycle({}))
duplicate_stages = {
    "Registration": ["Assessment", "Assessment"],
    "Assessment": ["Settlement"],
    "Settlement": []
}
print("Duplicate edge path:", " -> ".join(shortest_path(duplicate_stages, "Registration", "Settlement")))
