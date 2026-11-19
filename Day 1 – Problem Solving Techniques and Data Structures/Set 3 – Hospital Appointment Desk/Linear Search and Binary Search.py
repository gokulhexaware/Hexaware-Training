import time
patients = [{"patientId": i, "name": f"Patient_{i}"} for i in range(100001, 120001)]
def linear_search(data, target):
    for patient in data:
        if patient["patientId"] == target:
            return patient
    return None
def binary_search(data, target):
    low, high = 0, len(data) - 1
    while low <= high:
        mid = (low + high) // 2
        if data[mid]["patientId"] == target:
            return data[mid]
        elif data[mid]["patientId"] < target:
            low = mid + 1
        else:
            high = mid - 1
    return None
targets = [100001 + i * 20 for i in range(1000)]
start = time.perf_counter()
for target in targets:
    linear_search(patients, target)
linear_time = time.perf_counter() - start
start = time.perf_counter()
for target in targets:
    binary_search(patients, target)
binary_time = time.perf_counter() - start
print("Total patient records:", len(patients))
print("Total lookups:", len(targets))
print("Linear Search Time:", round(linear_time, 6), "seconds")
print("Binary Search Time:", round(binary_time, 6), "seconds")
print("Linear Search Result:", linear_search(patients, 100101))
print("Binary Search Result:", binary_search(patients, 100101))