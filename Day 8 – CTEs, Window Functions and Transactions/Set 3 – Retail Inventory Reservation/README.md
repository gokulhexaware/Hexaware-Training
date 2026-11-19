Set 3 – Retail Inventory Reservation

This set focuses on managing retail inventory, stock reservations and order processing using SQL Server and MongoDB.

Concepts Covered
- SQL Server transaction management
- BEGIN TRANSACTION, COMMIT and ROLLBACK
- TRY...CATCH error handling
- Stock availability validation
- Order and order-line management
- Rollback demonstration for insufficient stock
- Correlated subqueries
- Common Table Expressions (CTEs)
- ROW_NUMBER() and PARTITION BY
- Top three products by category
- LEAD() and LAG()
- Month-on-month sales analysis
- MongoDB atomic updates using $inc
- Single-document atomicity and multi-document transactions

Files Included
- reservation.sql – Inventory reservation, order creation, stock validation and correlated subqueries.
- rank_report.sql – Product sales ranking and monthly sales comparison using CTEs and window functions.
- stock_update.js – MongoDB atomic stock update implementation using $inc.
- inventory_notes.txt – Explanation of inventory transactions, correlated subqueries, window functions and MongoDB atomicity.

Objective
To understand how database transactions protect inventory consistency, prevent overselling, analyse product sales and perform atomic stock updates.

