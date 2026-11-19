def merge_claims(first, second):
    i = 0
    j = 0
    merged = []
    while i < len(first) and j < len(second):
        if first[i] <= second[j]:
            merged.append(first[i])
            i += 1
        else:
            merged.append(second[j])
            j += 1
    while i < len(first):
        merged.append(first[i])
        i += 1
    while j < len(second):
        merged.append(second[j])
        j += 1
    return merged
office_one = [101, 103, 105, 108, 110]
office_two = [102, 104, 105, 107, 109]
print("First regional office:", office_one)
print("Second regional office:", office_two)
print("Merged claim list:", merge_claims(office_one, office_two))
print("Empty lists:", merge_claims([], []))
print("First list empty:", merge_claims([], [101, 102, 103]))
print("Second list empty:", merge_claims([104, 105, 106], []))
print("Duplicate values:", merge_claims([101, 103, 103], [102, 103, 104]))
