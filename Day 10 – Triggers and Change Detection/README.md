Day 10 – Triggers and Change Detection

Project Overview

This project focuses on implementing database triggers and change detection techniques using Microsoft SQL Server and MongoDB.

The assignment covers automatic auditing, data validation, business rule enforcement, multi-row operations, nested and recursive triggers, and MongoDB Change Streams.

Three different real-world business scenarios are implemented to understand how database triggers help maintain data accuracy, consistency, and audit history.

Technologies Used

- Microsoft SQL Server 2025
- SQL Server Management Studio (SSMS)
- MongoDB 8.0
- MongoDB Shell (mongosh)
- Node.js
- MongoDB Node.js Driver
- SQL
- JavaScript

Set 1 – Retail Price Change Audit

Business Scenario:

A retailer needs to maintain a history of every product price change and prevent products from being sold below their cost price.

Implementation:

- Created product price and audit tables.
- Implemented an AFTER UPDATE trigger to record old price, new price, username, and timestamp.
- Implemented an INSTEAD OF UPDATE trigger to reject prices below cost.
- Recorded rejected price update attempts separately.
- Tested single-row and multi-row price updates.
- Implemented MongoDB Change Streams to monitor product price changes.
- Studied hidden logic, cascading triggers, and situations where application code is better.

Deliverables:

- triggers.sql
- test_evidence.sql
- watch_changes.js
- pitfalls.txt

Set 2 – Bank Account Balance Guard

Business Scenario:

A bank needs to maintain an audit history of account transactions and prevent savings account balances from becoming negative.

Implementation:

- Created bank account and transaction tables.
- Implemented an AFTER INSERT, UPDATE, and DELETE trigger to maintain transaction audit records.
- Created a view for account information.
- Implemented an INSTEAD OF UPDATE trigger to prevent negative savings balances.
- Used THROW to raise an error when the balance validation fails.
- Tested a batch update involving five accounts, including one invalid balance.
- Demonstrated nested trigger execution and examined recursive trigger settings.
- Implemented a MongoDB Change Stream to monitor new fraud alerts.

Deliverables:

- triggers.sql
- test_evidence.sql
- watch_alerts.js
- trigger_limits.txt

Set 3 – Hospital Bed Capacity Control

Business Scenario:

A hospital needs to prevent new admissions when a ward reaches its maximum bed capacity and maintain a history of admission changes.

Implementation:

- Created ward, admission, and admission audit tables.
- Implemented an INSTEAD OF INSERT trigger to check ward capacity before accepting admissions.
- Implemented an AFTER INSERT, UPDATE, and DELETE trigger to maintain admission history.
- Tested single-row and multi-row admission operations.
- Verified that an entire multi-row insert is rejected when one admission exceeds the ward capacity.
- Compared triggers with constraints and stored procedures.
- Implemented a MongoDB Change Stream to monitor critical ward alerts.

Deliverables:

- triggers.sql
- test_evidence.sql
- watch_wards.js
- justification.txt

Key Concepts Covered

SQL Server:

- AFTER Triggers
- INSTEAD OF Triggers
- INSERTED and DELETED Tables
- Multi-row Trigger Handling
- Audit Tables
- THROW Error Handling
- Nested Triggers
- Recursive Triggers
- Trigger Limitations
- Database Validation

MongoDB:

- Change Streams
- Replica Sets
- Collection Monitoring
- Insert and Update Events
- Real-time Change Detection
- Node.js MongoDB Driver

Project Structure

Day_10_Triggers_and_Change_Detection/

Set_1_Retail_Price_Change_Audit/
- triggers.sql
- test_evidence.sql
- watch_changes.js
- pitfalls.txt

Set_2_Bank_Account_Balance_Guard/
- triggers.sql
- test_evidence.sql
- watch_alerts.js
- trigger_limits.txt

Set_3_Hospital_Bed_Capacity_Control/
- triggers.sql
- test_evidence.sql
- watch_wards.js
- justification.txt

README.md

Execution Instructions

SQL Server:

1. Open SQL Server Management Studio.
2. Connect to your SQL Server instance.
3. Open the respective set's triggers.sql file.
4. Execute the script to create the database, tables, sample records, and triggers.
5. Open test_evidence.sql.
6. Execute the test cases.
7. Verify the results and audit records.

MongoDB:

1. Install MongoDB and Node.js.
2. Configure MongoDB as a replica set or use a sharded cluster.
3. Install the MongoDB Node.js driver using npm install mongodb.
4. Prepare the required collections and sample documents.
5. Run the respective JavaScript file using Node.js.
6. Insert or update documents from another MongoDB Shell session to observe the Change Stream events.

Learning Outcomes

- Understanding the difference between AFTER and INSTEAD OF triggers.
- Using INSERTED and DELETED tables for auditing.
- Handling multiple records safely inside triggers.
- Enforcing business rules at the database level.
- Understanding nested and recursive trigger behaviour.
- Comparing triggers, constraints, and stored procedures.
- Monitoring real-time database changes using MongoDB Change Streams.
- Understanding the role of replica sets in MongoDB.

Conclusion

This assignment provided practical experience with SQL Server triggers and MongoDB Change Streams through three different business scenarios.

The implementation demonstrates how database triggers can enforce business rules, maintain audit histories, and protect data consistency, while MongoDB Change Streams allow applications to respond to database changes.

Each set focuses on a different real-world requirement and provides practical experience in database auditing, validation, and change detection.

**Project: Hexaware Python Track – Day 10**  
**Topics: Triggers and Change Detection**  
**Technologies: SQL Server 2025 and MongoDB 8.0**
