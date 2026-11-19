def normalize(value):
    return "".join(value.split()).casefold()
def find_duplicates(claims):
    seen = {}
    duplicates = []
    for claim in claims:
        key = (normalize(claim["policy_number"]), normalize(claim["incident_date"]))
        if key in seen:
            duplicates.append((seen[key], claim["claim_id"]))
        else:
            seen[key] = claim["claim_id"]
    return duplicates
claims = [
    {"claim_id": "C101", "policy_number": "POL 123", "incident_date": "15-10-2026"},
    {"claim_id": "C102", "policy_number": "pol123", "incident_date": "15-10-2026"},
    {"claim_id": "C103", "policy_number": "POL456", "incident_date": "16-10-2026"},
    {"claim_id": "C104", "policy_number": " POL 456 ", "incident_date": "16-10-2026"}
]
print("Duplicate claims:", find_duplicates(claims))
print("Empty input:", find_duplicates([]))
duplicate_test = [
    {"claim_id": "C201", "policy_number": "POL789", "incident_date": "20-10-2026"},
    {"claim_id": "C202", "policy_number": "POL789", "incident_date": "20-10-2026"}
]
print("Exact duplicate test:", find_duplicates(duplicate_test))
