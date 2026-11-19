from collections import deque
dependencies = {
    "cart": ["pricing"],
    "pricing": ["inventory"],
    "inventory": ["payment"],
    "payment": ["notification"],
    "notification": []
}
def bfs_order(graph):
    indegree = {node: 0 for node in graph}
    for neighbors in graph.values():
        for neighbor in neighbors:
            indegree[neighbor] += 1

    queue = deque(node for node in graph if indegree[node] == 0)
    order = []
    while queue:
        node = queue.popleft()
        order.append(node)
        for neighbor in graph[node]:
            indegree[neighbor] -= 1
            if indegree[neighbor] == 0:
                queue.append(neighbor)

    return order if len(order) == len(graph) else None

def dfs_order(graph):
    visited = set()
    active = set()
    order = []
    has_cycle = False

    def visit(node):
        nonlocal has_cycle
        if node in active:
            has_cycle = True
            return
        if node in visited:
            return

        active.add(node)
        for neighbor in graph[node]:
            visit(neighbor)
        active.remove(node)
        visited.add(node)
        order.append(node)

    for node in graph:
        visit(node)
    return None if has_cycle else order[::-1]
print("BFS deployment order:", " -> ".join(bfs_order(dependencies)))
print("DFS deployment order:", " -> ".join(dfs_order(dependencies)))
cyclic_dependencies = {node: neighbors[:] for node, neighbors in dependencies.items()}
cyclic_dependencies["notification"].append("cart")
print("Circular dependency detected:", bfs_order(cyclic_dependencies) is None)
