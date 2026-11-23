Day 9 Assignment

Views, Stored Procedures, Functions and Cursors

This repository contains the Day 9 SQL Server and MongoDB assignments completed as part of the Hexaware Python Training Program.

The assignment focuses on implementing database-level business logic using SQL Server 2025 and MongoDB 8.0 through three different business scenarios.

Technologies Used

- Microsoft SQL Server 2025
- SQL
- MongoDB 
- MongoDB Shell

Assignment Overview

Set 1 – Retail Order Fulfilment

Implemented database operations for managing retail orders, product stock and order follow-ups.

Tasks Covered:
- Created `vw_order_summary` and `vw_low_stock` views.
- Demonstrated an updatable view using `WITH CHECK OPTION`.
- Developed `usp_PlaceOrder` with input parameters, OUTPUT parameter and transaction handling.
- Implemented scalar and table-valued functions for order calculations.
- Created cursor-based and set-based approaches for pending order follow-ups.
- Created a MongoDB view to display order status counts.
- Compared cursor and set-based approaches.

Files:
- views.sql
- procedures.sql
- cursor.sql
- mongo_view.js
- comparison.txt

Set 2 – Insurance Premium Processing

Implemented policy renewal operations with premium calculations, validations and audit logging.

Tasks Covered:
- Created `vw_policy_due` to display policies due within 30 days.
- Developed `usp_RenewPolicy` with policy validation and transaction handling.
- Implemented premium calculation using a scalar function.
- Created a table-valued function for agent renewal quotes.
- Implemented cursor-based and set-based approaches for updating lapsed policies.
- Added audit logging for policy status changes.
- Created a MongoDB view to display unresolved customer complaints.
- Compared cursor and set-based approaches.

Files:
- views.sql
- procedures.sql
- cursor.sql
- mongo_view.js
- comparison.txt

Set 3 – Telecom Low-Balance Follow-up

Implemented prepaid subscriber management, recharge processing and low-balance notifications.

Tasks Covered:
- Created `vw_prepaid_subscribers` and `vw_recharge_summary` views.
- Applied view filtering to hide postpaid subscribers.
- Developed `usp_Recharge` with amount and plan validation, transaction handling and OUTPUT parameter.
- Implemented `fn_ValidityDaysLeft` and a table-valued function for the last five recharges.
- Created cursor-based and set-based approaches for low-balance notifications.
- Measured and compared execution time.
- Created a MongoDB view to display unread notification counts per subscriber.

Files:
- views.sql
- procedures.sql
- cursor.sql
- mongo_view.js
- timing_comparison.txt

Key SQL Concepts Practiced

- Creating and managing SQL views
- Updatable views and WITH CHECK OPTION
- Stored procedures with input and OUTPUT parameters
- Scalar functions
- Inline table-valued functions
- Table-valued parameters
- Transactions using BEGIN TRANSACTION and COMMIT
- Error handling using TRY...CATCH
- Stock and business rule validation
- Cursor declarations and operations
- Set-based INSERT and UPDATE operations
- OUTPUT clause
- Execution-time measurement

ongoDB Concepts Practiced

- Creating MongoDB views using `db.createView()`
- Aggregation pipelines
- Filtering using `$match`
- Grouping using `$group`
- Counting records using `$sum`
- Selecting fields using `$project`
- Sorting using `$sort`

Learning Outcome

Through these three assignments, I gained practical experience in implementing business logic at the database level, developing reusable SQL functions and stored procedures, handling transactions, processing records using cursors and set-based operations, and creating MongoDB views using aggregation pipelines.

The assignments also helped me understand the differences between row-by-row processing and set-based database operations in real-world business scenarios.

---

**Hexaware Training Program | Python Track | Day 9
