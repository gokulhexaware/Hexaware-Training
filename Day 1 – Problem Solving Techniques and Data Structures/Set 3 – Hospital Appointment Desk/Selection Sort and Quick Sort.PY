import random
import time
from datetime import datetime, timedelta
random.seed(42)
appointments = []
base_time = datetime(2026, 11, 19, 9, 0)
for i in range(1, 2001):
    appointments.append({"appointmentId": i, "urgencyLevel": random.randint(1, 5), "arrivalTime": (base_time + timedelta(minutes=random.randint(0, 300))).strftime("%H:%M")})
def appointment_key(item):
    return item["urgencyLevel"], item["arrivalTime"]
def selection_sort(data):
    arr = data.copy()
    swaps = 0
    for i in range(len(arr)):
        min_index = i
        for j in range(i + 1, len(arr)):
            if appointment_key(arr[j]) < appointment_key(arr[min_index]):
                min_index = j
        if min_index != i:
            arr[i], arr[min_index] = arr[min_index], arr[i]
            swaps += 1
    return arr, swaps
def quick_sort(data):
    arr = data.copy()
    swaps = 0
    def partition(low, high):
        nonlocal swaps
        pivot = appointment_key(arr[(low + high) // 2])
        i, j = low, high
        while i <= j:
            while appointment_key(arr[i]) < pivot:
                i += 1
            while appointment_key(arr[j]) > pivot:
                j -= 1
            if i <= j:
                if i != j:
                    arr[i], arr[j] = arr[j], arr[i]
                    swaps += 1
                i += 1
                j -= 1
        return i
    def sort(low, high):
        if low < high:
            index = partition(low, high)
            if low < index - 1:
                sort(low, index - 1)
            if index < high:
                sort(index, high)
    sort(0, len(arr) - 1)
    return arr, swaps
start = time.perf_counter()
selection_result, selection_swaps = selection_sort(appointments)
selection_time = time.perf_counter() - start
start = time.perf_counter()
quick_result, quick_swaps = quick_sort(appointments)
quick_time = time.perf_counter() - start
print("Total appointments:", len(appointments))
print("Selection Sort Swaps:", selection_swaps)
print("Selection Sort Time:", round(selection_time, 6), "seconds")
print("Quick Sort Swaps:", quick_swaps)
print("Quick Sort Time:", round(quick_time, 6), "seconds")
print("First 5 sorted appointments:")
for appointment in quick_result[:5]:
    print(appointment)