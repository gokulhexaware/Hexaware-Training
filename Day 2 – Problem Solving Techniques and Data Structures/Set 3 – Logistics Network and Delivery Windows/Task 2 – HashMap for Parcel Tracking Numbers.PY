def check_duplicate_scans(scans):
    scanned = {}
    duplicates = []
    for tracking_number, hub in scans:
        key = (tracking_number.casefold(), hub.casefold())
        if key in scanned:
            duplicates.append((tracking_number, hub))
        else:
            scanned[key] = True
    return duplicates
parcel_scans = [
    ("TRK101", "H01"),
    ("TRK102", "H02"),
    ("TRK103", "H03"),
    ("TRK101", "H01"),
    ("TRK104", "H04"),
    ("TRK102", "H05"),
    ("TRK103", "H03")
]
print("Duplicate parcel scans:", check_duplicate_scans(parcel_scans))
print("Empty input:", check_duplicate_scans([]))
duplicate_test = [
    ("TRK201", "H01"),
    ("TRK201", "H01"),
    ("TRK201", "H02")
]
print("Duplicate test:", check_duplicate_scans(duplicate_test))
case_test = [
    ("TRK301", "H01"),
    ("trk301", "h01")
]
print("Case-insensitive duplicate test:", check_duplicate_scans(case_test))
