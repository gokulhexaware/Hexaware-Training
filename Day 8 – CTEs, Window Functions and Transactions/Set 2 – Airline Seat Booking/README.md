Set 2 – Airline Seat Booking

This set focuses on developing a reliable airline seat booking system using SQL Server transactions, window functions and MongoDB transactions.

Concepts Covered
- SQL Server transaction management
- BEGIN TRANSACTION, COMMIT and ROLLBACK
- TRY...CATCH error handling
- Seat availability validation
- Duplicate booking prevention
- READ COMMITTED and SERIALIZABLE isolation levels
- Concurrent transaction handling
- RANK() and DENSE_RANK()
- Common Table Expressions (CTEs)
- SUM() OVER() and running revenue
- MongoDB sessions and multi-document transactions

Files Included
- booking_transaction.sql – Seat booking transactions, error handling and duplicate booking prevention.
- ranking_report.sql – Passenger fare ranking and running revenue reports using window functions and CTEs.
- booking_txn.js – MongoDB seat reservation and booking transaction implementation.
- booking_notes.txt – Explanation of transaction behaviour, concurrency testing, ranking functions and MongoDB transactions.

Objective
To understand how database transactions maintain booking consistency, prevent duplicate seat reservations and manage concurrent booking requests.

