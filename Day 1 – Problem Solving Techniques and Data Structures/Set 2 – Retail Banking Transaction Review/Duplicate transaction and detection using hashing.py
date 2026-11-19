from datetime import datetime
transactions = [
    {
        "transactionId": 101,
        "accountId": 5001,
        "amount": 1500,
        "merchant": "Amazon",
        "postingTime": "2026-11-18 10:00:10"
    },
    {
        "transactionId": 102,
        "accountId": 5001,
        "amount": 1500,
        "merchant": "Amazon",
        "postingTime": "2026-11-18 10:00:45"
    },
    {
        "transactionId": 103,
        "accountId": 5002,
        "amount": 2500,
        "merchant": "Flipkart",
        "postingTime": "2026-11-18 10:02:00"
    },
    {
        "transactionId": 104,
        "accountId": 5001,
        "amount": 1500,
        "merchant": "Amazon",
        "postingTime": "2026-11-18 10:03:00"
    },
    {
        "transactionId": 105,
        "accountId": 5002,
        "amount": 2500,
        "merchant": "Flipkart",
        "postingTime": "2026-11-18 10:02:50"
    }
]
def detect_duplicates(transactions):
    transactions = sorted(
        transactions,
        key=lambda transaction: datetime.strptime(
            transaction["postingTime"],
            "%Y-%m-%d %H:%M:%S"
        )
    )
    seen = {}
    duplicates = []
    for transaction in transactions:

        key = (
            transaction["accountId"],
            transaction["amount"],
            transaction["merchant"]
        )

        current_time = datetime.strptime(
            transaction["postingTime"],
            "%Y-%m-%d %H:%M:%S"
        )

        if key in seen:

            previous_transaction, previous_time = seen[key]

            difference = (
                current_time - previous_time
            ).total_seconds()

            if difference <= 60:
                duplicates.append({
                    "original": previous_transaction,
                    "duplicate": transaction,
                    "timeDifference": difference
                })
        seen[key] = (transaction, current_time)
    return duplicates
duplicates = detect_duplicates(transactions)
print("--- Duplicate Transactions ---")
if duplicates:
    for duplicate in duplicates:
        print(
            "Original Transaction:",
            duplicate["original"]["transactionId"],
            "| Duplicate Transaction:",
            duplicate["duplicate"]["transactionId"],
            "| Difference:",
            duplicate["timeDifference"],
            "seconds"
        )
else:
    print("No duplicate transactions found.")