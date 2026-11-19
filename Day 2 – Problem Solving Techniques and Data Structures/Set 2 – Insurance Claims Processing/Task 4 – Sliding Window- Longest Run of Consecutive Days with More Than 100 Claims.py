def longest_claim_run(claims):
    if not claims:
        return 0, []
    left = 0
    max_length = 0
    best_run = []
    for right in range(len(claims)):
        if claims[right] <= 100:
            left = right + 1
        current_length = right - left + 1
        if current_length > max_length:
            max_length = current_length
            best_run = claims[left:right + 1]
    return max_length, best_run
daily_claims = [85, 120, 135, 145, 90, 115, 125, 130, 140, 95, 110, 105]
length, run = longest_claim_run(daily_claims)
print("Longest consecutive run:", length, "days")
print("Claims during the longest run:", run)
empty_test = []
print("Empty input:", longest_claim_run(empty_test))
duplicate_test = [110, 110, 120, 120, 95, 130, 130]
print("Duplicate values test:", longest_claim_run(duplicate_test))
