import random
import time
# Generate 10,000 orders
random.seed(42)
orders = [
    {
        "orderId": i,
        "amount": round(random.uniform(100, 10000), 2)
    }
    for i in range(1, 10001)
]
# Bubble Sort - Descending Order
def bubble_sort(data):
    arr = data.copy()
    n = len(arr)
    comparisons = 0
    swaps = 0
    for i in range(n):
        for j in range(0, n - i - 1):
            comparisons += 1

            if arr[j]["amount"] < arr[j + 1]["amount"]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swaps += 1
    return arr, comparisons, swaps
# Merge Sort - Descending Order
def merge_sort(data):
    if len(data) <= 1:
        return data.copy()
    mid = len(data) // 2
    left = merge_sort(data[:mid])
    right = merge_sort(data[mid:])
    return merge(left, right)
def merge(left, right):
    result = []
    i = 0
    j = 0
    while i < len(left) and j < len(right):
        if left[i]["amount"] >= right[j]["amount"]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
# Built-in Sort
def builtin_sort(data):
    return sorted(
        data,
        key=lambda order: order["amount"],
        reverse=True
    )
# Bubble Sort Benchmark
start = time.perf_counter()
bubble_result, comparisons, swaps = bubble_sort(orders)
bubble_time = time.perf_counter() - start
# Merge Sort Benchmark
start = time.perf_counter()
merge_result = merge_sort(orders)
merge_time = time.perf_counter() - start
# Built-in Sort Benchmark
start = time.perf_counter()
builtin_result = builtin_sort(orders)
builtin_time = time.perf_counter() - start
# Display results
print("\n--- Sorting Results ---")
print("Bubble Sort Time:", bubble_time)
print("Bubble Comparisons:", comparisons)
print("Bubble Swaps:", swaps)
print("\nMerge Sort Time:", merge_time)
print("\nBuilt-in Sort Time:", builtin_time)
print("\n--- First 5 Sorted Orders ---")
for order in merge_result[:5]:
    print(order)
print("\n--- Verification ---")
print(
    "Bubble Sort Correct:",
    bubble_result == merge_result
)
print(
    "Built-in Sort Correct:",
    builtin_result == merge_result
)