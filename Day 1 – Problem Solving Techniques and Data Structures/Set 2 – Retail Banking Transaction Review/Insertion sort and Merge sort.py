from datetime import datetime
import random
import time
transactions = [
    {
        "transactionId": i,
        "amount": random.randint(100, 10000),
        "postingDate": date
    }
    for i, date in enumerate([
        "2026-11-18 10:30:00",
        "2026-11-18 09:15:00",
        "2026-11-18 10:30:00",
        "2026-11-18 11:45:00",
        "2026-11-18 09:15:00",
        "2026-11-18 12:00:00",
        "2026-11-18 10:30:00",
        "2026-11-18 08:30:00"
    ], start=101)
]
def insertion_sort(data):
    arr = data.copy()
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while (
            j >= 0
            and datetime.fromisoformat(arr[j]["postingDate"])
            > datetime.fromisoformat(key["postingDate"])
        ):
            arr[j + 1] = arr[j]
            j -= 1

        arr[j + 1] = key

    return arr
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

        left_date = datetime.fromisoformat(left[i]["postingDate"])
        right_date = datetime.fromisoformat(right[j]["postingDate"])

        if left_date <= right_date:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result
print("--- Original Transactions ---")
for transaction in transactions:
    print(transaction)
start = time.perf_counter()
insertion_result = insertion_sort(transactions)
insertion_time = time.perf_counter() - start
start = time.perf_counter()
merge_result = merge_sort(transactions)
merge_time = time.perf_counter() - start
print("\n--- Insertion Sort ---")
for transaction in insertion_result:
    print(transaction)
print("Execution Time:", insertion_time)
print("\n--- Merge Sort ---")
for transaction in merge_result:
    print(transaction)
print("Execution Time:", merge_time)
print("\n--- Stability Verification ---")
for transaction in merge_result:
    print(
        transaction["transactionId"],
        transaction["postingDate"]
    )