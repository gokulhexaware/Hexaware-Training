def highest_average_window(parcel_counts, window_size):
    if not parcel_counts or window_size <= 0 or window_size > len(parcel_counts):
        return None
    current_sum = sum(parcel_counts[:window_size])
    max_sum = current_sum
    best_start = 0
    for i in range(window_size, len(parcel_counts)):
        current_sum += parcel_counts[i] - parcel_counts[i - window_size]
        if current_sum > max_sum:
            max_sum = current_sum
            best_start = i - window_size + 1
    return best_start, max_sum, max_sum / window_size
hourly_counts = [20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75]
result = highest_average_window(hourly_counts, 4)
if result:
    start, total, average = result
    print("Highest average 4-hour window:")
    print(f"Hours {start + 1} to {start + 4}")
    print("Parcel counts:", hourly_counts[start:start + 4])
    print("Total parcels:", total)
    print(f"Average parcels per hour: {average:.2f}")
print("Empty input:", highest_average_window([], 4))
print("Window larger than input:", highest_average_window([10, 20], 4))
print("Duplicate values:", highest_average_window([50, 50, 50, 50, 50], 4))
