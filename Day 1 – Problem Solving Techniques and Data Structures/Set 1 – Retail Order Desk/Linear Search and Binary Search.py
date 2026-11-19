import csv
import random
import time
from datetime import datetime, timedelta
def create_orders_file():
    random.seed(42)
    with open("orders.csv", "w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow([
            "orderId", "customerId", "amount", "createdAt"
        ])
        start_date = datetime(2026, 1, 1)
        for i in range(1, 50001):
            writer.writerow([
                i,
                random.randint(1000, 9999),
                round(random.uniform(100, 10000), 2),
                (start_date + timedelta(minutes=i)).isoformat()
            ])
    print("orders.csv created successfully.")
# Load orders from CSV
def load_orders():
    try:
        with open("orders.csv", "r") as file:
            reader = csv.DictReader(file)
            return list(reader)

    except FileNotFoundError:
        create_orders_file()
        return load_orders()
# Linear Search
def linear_search(orders, target_id):
    comparisons = 0

    for order in orders:
        comparisons += 1

        if int(order["orderId"]) == target_id:
            return order, comparisons

    return None, comparisons
# Binary Search
def binary_search(orders, target_id):
    low = 0
    high = len(orders) - 1
    comparisons = 0

    while low <= high:
        mid = (low + high) // 2
        comparisons += 1

        current_id = int(orders[mid]["orderId"])

        if current_id == target_id:
            return orders[mid], comparisons

        elif current_id < target_id:
            low = mid + 1
        else:
            high = mid - 1
    return None, comparisons
# Main program
orders = load_orders()
target_id = 50000
print("\nTotal orders:", len(orders))
print("Searching for Order ID:", target_id)
# Linear Search Benchmark
start = time.perf_counter()
linear_result, linear_comparisons = linear_search(
    orders, target_id
)
linear_time = time.perf_counter() - start
# Binary Search Benchmark
start = time.perf_counter()
binary_result, binary_comparisons = binary_search(
    orders, target_id
)
binary_time = time.perf_counter() - start
print("\n--- Linear Search ---")
print("Result:", linear_result)
print("Comparisons:", linear_comparisons)
print("Time:", linear_time)
print("\n--- Binary Search ---")
print("Result:", binary_result)
print("Comparisons:", binary_comparisons)
print("Time:", binary_time)
print("\n--- Comparison ---")
print("Linear Search Complexity: O(n)")
print("Binary Search Complexity: O(log n)")