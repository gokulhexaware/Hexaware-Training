requests = [120, 135, 150, 180, 220, 260, 310, 340, 390, 420, 460, 500, 480, 450, 430, 410, 380, 350, 320, 290, 250, 210, 170, 140]
window_size = 3
window_sum = sum(requests[:window_size])
max_sum = window_sum
best_start = 0
for index in range(window_size, len(requests)):
    window_sum += requests[index] - requests[index - window_size]
    if window_sum > max_sum:
        max_sum = window_sum
        best_start = index - window_size + 1
print("Busiest 3-hour window:")
print(f"Hours {best_start + 1} to {best_start + window_size}")
print(f"Requests: {requests[best_start:best_start + window_size]}")
print("Total requests:", max_sum)
print(f"Average requests per hour: {max_sum / window_size:.2f}")
