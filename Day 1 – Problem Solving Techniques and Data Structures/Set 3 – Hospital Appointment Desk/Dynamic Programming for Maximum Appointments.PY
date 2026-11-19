from bisect import bisect_right
appointments = [
    {"appointmentId": "A", "start": 9 * 60, "end": 9 * 60 + 5},
    {"appointmentId": "B", "start": 9 * 60 + 5, "end": 9 * 60 + 10},
    {"appointmentId": "C", "start": 9 * 60 + 4, "end": 9 * 60 + 6}
]
def dynamic_programming(data):
    arr = sorted(data, key=lambda x: x["end"])
    ends = [appointment["end"] for appointment in arr]
    dp = [0] * (len(arr) + 1)
    for i in range(1, len(arr) + 1):
        previous = bisect_right(ends, arr[i - 1]["start"], 0, i - 1)
        include = 1 + dp[previous]
        exclude = dp[i - 1]
        dp[i] = max(include, exclude)
    selected = []
    i = len(arr)
    while i > 0:
        previous = bisect_right(ends, arr[i - 1]["start"], 0, i - 1)
        if 1 + dp[previous] > dp[i - 1]:
            selected.append(arr[i - 1]["appointmentId"])
            i = previous
        else:
            i -= 1
    return dp[-1], selected[::-1]
def earliest_finish_greedy(data):
    arr = sorted(data, key=lambda x: x["end"])
    selected = []
    last_end = -1
    for appointment in arr:
        if appointment["start"] >= last_end:
            selected.append(appointment["appointmentId"])
            last_end = appointment["end"]
    return selected
def shortest_duration_greedy(data):
    arr = sorted(data, key=lambda x: x["end"] - x["start"])
    selected = []
    for appointment in arr:
        if all(appointment["end"] <= item["start"] or appointment["start"] >= item["end"] for item in [next(a for a in data if a["appointmentId"] == selected_id) for selected_id in selected]):
            selected.append(appointment["appointmentId"])
    return selected
dp_count, dp_selected = dynamic_programming(appointments)
finish_selected = earliest_finish_greedy(appointments)
duration_selected = shortest_duration_greedy(appointments)
print("Dynamic Programming Maximum Appointments:", dp_count)
print("DP Selected Appointments:", dp_selected)
print("Earliest Finish Greedy Count:", len(finish_selected))
print("Earliest Finish Greedy Selected:", finish_selected)
print("Shortest Duration Greedy Count:", len(duration_selected))
print("Shortest Duration Greedy Selected:", duration_selected)