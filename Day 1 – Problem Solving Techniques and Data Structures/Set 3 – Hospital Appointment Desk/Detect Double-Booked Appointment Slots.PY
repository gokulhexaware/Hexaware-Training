appointments = [
    {"appointmentId": 101, "patientId": 1001, "slot": "09:00"},
    {"appointmentId": 102, "patientId": 1002, "slot": "09:30"},
    {"appointmentId": 103, "patientId": 1001, "slot": "09:00"},
    {"appointmentId": 104, "patientId": 1003, "slot": "10:00"},
    {"appointmentId": 105, "patientId": 1002, "slot": "09:30"},
    {"appointmentId": 106, "patientId": 1001, "slot": "10:00"}
]
booked_slots = set()
duplicates = []
for appointment in appointments:
    key = (appointment["patientId"], appointment["slot"])
    if key in booked_slots:
        duplicates.append(appointment)
    else:
        booked_slots.add(key)
print("Double-booked appointments:")
for appointment in duplicates:
    print(appointment)
print("Total double bookings:", len(duplicates))