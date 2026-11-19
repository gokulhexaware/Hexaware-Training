from datetime import datetime
orders = [
    {
        "orderId": 101,
        "customerId": 1001,
        "amount": 500,
        "createdAt": "2026-11-18 10:01:10"
    },
    {
        "orderId": 102,
        "customerId": 1001,
        "amount": 500,
        "createdAt": "2026-11-18 10:01:45"
    },
    {
        "orderId": 103,
        "customerId": 1002,
        "amount": 700,
        "createdAt": "2026-11-18 10:02:10"
    },
    {
        "orderId": 104,
        "customerId": 1001,
        "amount": 500,
        "createdAt": "2026-11-18 10:03:10"
    },
    {
        "orderId": 105,
        "customerId": 1002,
        "amount": 700,
        "createdAt": "2026-11-18 10:02:40"
    }
]
def detect_duplicates(orders):
    seen = {}
    duplicates = []
    for order in orders:

        created_time = datetime.strptime(
            order["createdAt"],
            "%Y-%m-%d %H:%M:%S"
        )
        minute = created_time.strftime("%Y-%m-%d %H:%M")
        key = (
            order["customerId"],
            order["amount"],
            minute
        )
        if key in seen:

            duplicates.append({
                "originalOrder": seen[key],
                "duplicateOrder": order
            })
        else:
            seen[key] = order

    return duplicates
duplicates = detect_duplicates(orders)
print("--- Duplicate Orders ---")
if duplicates:
    for duplicate in duplicates:
        print(
            "Original:",
            duplicate["originalOrder"]["orderId"],
            "| Duplicate:",
            duplicate["duplicateOrder"]["orderId"]
        )
else:
    print("No duplicate orders found.")