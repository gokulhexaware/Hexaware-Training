Day 8 – CTEs, Window Functions and Transactions

A complete hands-on assignment covering SQL Server transactions, Common Table Expressions, window functions, transaction isolation and MongoDB transactions through three real-world business scenarios.

Assignment Overview

This assignment is divided into three sets, each focusing on practical database operations and transaction management.

Set 1 – Bank Funds Transfer

Implemented a secure bank funds transfer system ensuring that debit and credit operations succeed together or are completely rolled back.

Topics Covered:
- BEGIN TRANSACTION, COMMIT and ROLLBACK
- TRY...CATCH and THROW
- SAVEPOINT and partial rollback
- Common Table Expressions
- ROW_NUMBER() and LAG()
- READ COMMITTED and SNAPSHOT isolation
- MongoDB multi-document transactions

Files:
- transfer.sql
- statement_cte.sql
- transaction.js
- isolation_notes.txt

Set 2 – Airline Seat Booking

Implemented an airline seat booking system with transaction handling, duplicate booking prevention and concurrent booking demonstrations.

Topics Covered:
- SQL Server transaction management
- Seat availability validation
- Duplicate booking prevention
- READ COMMITTED and SERIALIZABLE isolation
- Concurrent transaction handling
- RANK() and DENSE_RANK()
- SUM() OVER() and running revenue
- MongoDB sessions and transactions

Files:
- booking_transaction.sql
- ranking_report.sql
- booking_txn.js
- booking_notes.txt

Set 3 – Retail Inventory Reservation

Implemented a retail inventory reservation system to manage product stock, order creation and sales analysis.

Topics Covered:
- SQL Server transaction management
- Stock validation and rollback
- Correlated subqueries
- Common Table Expressions
- ROW_NUMBER() and PARTITION BY
- Top three products by category
- LEAD() and LAG()
- Month-on-month sales analysis
- MongoDB atomic updates using $inc
- Single-document and multi-document transactions

Files:
- reservation.sql
- rank_report.sql
- stock_update.js
- inventory_notes.txt

Technologies Used

- Microsoft SQL Server 2025
- SQL Server Management Studio (SSMS)
- MongoDB 8.0
- JavaScript
- SQL

Key Learning Outcomes

- Understanding ACID properties and database transactions.
- Implementing COMMIT and ROLLBACK operations.
- Handling transaction failures using TRY...CATCH.
- Working with SAVEPOINT for partial rollback.
- Writing and applying Common Table Expressions.
- Using window functions for ranking and analytical reports.
- Understanding transaction isolation levels.
- Handling concurrent database operations.
- Implementing MongoDB atomic updates and multi-document transactions.
- Applying database concepts to practical business scenarios.

Conclusion

Day 8 provided practical experience in SQL Server transaction management, CTEs, window functions, concurrency handling and MongoDB transactions through banking, airline booking and retail inventory scenarios.

Each set demonstrates how database concepts can be applied to real-world applications while maintaining data consistency, accuracy and reliability.
