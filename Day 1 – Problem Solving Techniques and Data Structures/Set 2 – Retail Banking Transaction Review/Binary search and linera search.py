import time
transaction_ids = list(range(100001, 200001))
def linear_search(data, target):
    comparisons = 0
    for transaction_id in data:
        comparisons += 1
        if transaction_id == target:
            return transaction_id, comparisons
    return None, comparisons
def binary_search(data, target):
    low = 0
    high = len(data) - 1
    comparisons = 0
    while low <= high:
        mid = (low + high) // 2
        comparisons += 1
        if data[mid] == target:
            return data[mid], comparisons
        elif data[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return None, comparisons
# Best Case
best_target = transaction_ids[len(transaction_ids) // 2]
# Average Case: calculate comparisons for every successful lookup
total_binary_comparisons = 0
for target in transaction_ids:
    _, comparisons = binary_search(transaction_ids, target)
    total_binary_comparisons += comparisons
average_binary_comparisons = total_binary_comparisons / len(transaction_ids)
# Worst Case: unsuccessful search
worst_target = 200001
print("Total Transaction IDs:", len(transaction_ids))
print("\n--- Binary Search ---")
result, comparisons = binary_search(transaction_ids, best_target)
print("Best Case Target:", best_target)
print("Best Case Comparisons:", comparisons)
print("Average Case Comparisons:", average_binary_comparisons)
result, comparisons = binary_search(transaction_ids, worst_target)
print("Worst Case Target:", worst_target)
print("Worst Case Comparisons:", comparisons)
# Linear Search Comparisons
print("\n--- Linear Search ---")
_, best_linear = linear_search(transaction_ids, transaction_ids[0])
_, average_linear = linear_search(transaction_ids, transaction_ids[len(transaction_ids) // 2])
_, worst_linear = linear_search(transaction_ids, 200001)
print("Best Case Comparisons:", best_linear)
print("Average Case Comparisons:", average_linear)
print("Worst Case Comparisons:", worst_linear)
# Benchmark
target = 150000
start = time.perf_counter()
linear_result, linear_comparisons = linear_search(transaction_ids, target)
linear_time = time.perf_counter() - start
start = time.perf_counter()
binary_result, binary_comparisons = binary_search(transaction_ids, target)
binary_time = time.perf_counter() - start
print("\n--- Performance Comparison ---")
print("Linear Search Time:", linear_time)
print("Binary Search Time:", binary_time)
print("Linear Comparisons:", linear_comparisons)
print("Binary Comparisons:", binary_comparisons)