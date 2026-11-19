Set 1 – Bank Funds Transfer

This set focuses on implementing secure bank fund transfers using SQL Server transactions and MongoDB multi-document transactions.

Concepts Covered
- BEGIN TRANSACTION, COMMIT and ROLLBACK
- TRY...CATCH error handling and THROW
- SAVEPOINT and partial rollback
- Transaction validation and account balance management
- Common Table Expressions (CTEs)
- ROW_NUMBER() and LAG()
- READ COMMITTED and SNAPSHOT isolation levels
- MongoDB multi-document transactions

Files Included
- transfer.sql – Funds transfer, transaction handling, rollback demonstration and SAVEPOINT implementation.
- statement_cte.sql – Monthly bank statement using CTEs, ROW_NUMBER() and LAG().
- transaction.js – MongoDB multi-document funds transfer implementation.
- isolation_notes.txt – Explanation of isolation levels, two-session examples and MongoDB transaction costs.

Objective
To understand how database transactions maintain data consistency, ensure atomic money transfers and handle failures without affecting account balances.

