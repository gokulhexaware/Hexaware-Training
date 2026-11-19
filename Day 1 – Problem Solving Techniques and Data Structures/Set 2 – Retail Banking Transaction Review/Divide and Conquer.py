import random
import time
random.seed(42)
transactions = [
    {
        "transactionId": i,
        "amount": round(random.uniform(100, 50000), 2)
    }
    for i in range(1, 10001)
]
# Brute Force Approach
def brute_force_min_max(data):
    minimum = data[0]["amount"]
    maximum = data[0]["amount"]
    comparisons = 0
    for transaction in data[1:]:
        comparisons += 1
        if transaction["amount"] < minimum:
            minimum = transaction["amount"]
        comparisons += 1
        if transaction["amount"] > maximum:
            maximum = transaction["amount"]
    return minimum, maximum, comparisons
# Divide-and-Conquer Approach
def divide_conquer_min_max(data):

    if len(data) == 1:
        amount = data[0]["amount"]
        return amount, amount, 0

    if len(data) == 2:

        first = data[0]["amount"]
        second = data[1]["amount"]

        if first < second:
            return first, second, 1

        return second, first, 1

    mid = len(data) // 2

    left_min, left_max, left_count = divide_conquer_min_max(
        data[:mid]
    )

    right_min, right_max, right_count = divide_conquer_min_max(
        data[mid:]
    )

    minimum = min(left_min, right_min)
    maximum = max(left_max, right_max)

    comparisons = left_count + right_count + 2

    return minimum, maximum, comparisons
# Brute Force Benchmark
start = time.perf_counter()

brute_min, brute_max, brute_comparisons = brute_force_min_max(
    transactions
)

brute_time = time.perf_counter() - start


# Divide-and-Conquer Benchmark
start = time.perf_counter()

divide_min, divide_max, divide_comparisons = divide_conquer_min_max(
    transactions
)

divide_time = time.perf_counter() - start
print("--- Brute Force Approach ---")
print("Minimum Amount:", brute_min)
print("Maximum Amount:", brute_max)
print("Comparisons:", brute_comparisons)
print("Execution Time:", brute_time)
print("\n--- Divide-and-Conquer Approach ---")
print("Minimum Amount:", divide_min)
print("Maximum Amount:", divide_max)
print("Comparisons:", divide_comparisons)
print("Execution Time:", divide_time)
print("\n--- Verification ---")
print("Minimum Match:", brute_min == divide_min)
print("Maximum Match:", brute_max == divide_max)