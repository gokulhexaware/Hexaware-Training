Set 2 - Utility Billing Calculator

Electricity Slabs

- 0-100 units: Rs. 1.50 per unit
- 101-200 units: Rs. 2.50 per unit
- 201-400 units: Rs. 4.00 per unit
- Above 400 units: Rs. 6.00 per unit

The calculator uses progressive slab billing.

Fixed Charges

- Domestic: Rs. 50
- Commercial: Rs. 150
- Industrial: Rs. 300

Additional Charges

- Late payment surcharge: 5%
- Online payment rebate: 2%

Boundary Test Cases

| Units | Expected Energy Charge |
|---|---:|
| 100 | Rs. 150.00 |
| 101 | Rs. 152.50 |
| 200 | Rs. 400.00 |
| 201 | Rs. 404.00 |
| 400 | Rs. 1200.00 |
| 401 | Rs. 1206.00 |

Other Test Cases

| Test | Expected Result |
|---|---|
| Domestic category | Rs. 50 fixed charge |
| Commercial category | Rs. 150 fixed charge |
| Industrial category | Rs. 300 fixed charge |
| Invalid category | Error message |
| Negative units | Invalid reading |
| Alphabetic reading | Invalid reading |
| Empty reading | Invalid reading |
| Late payment | 5% surcharge |
| Online payment | 2% rebate |
| Late and online payment | Both adjustments applied |
| Enter q | Interactive loop terminates |

Monthly Statement

The program processes 12 months of sample electricity consumption using a for loop.

Interactive Reading

The program accepts consumption readings using a while loop and terminates when the user enters q.

Operator Precedence

The final bill calculation uses multiplication before addition and subtraction. Parentheses explicitly group the conditional surcharge and rebate calculations.

Technology

- Python 3.13
- If-elif statements
- Match/case
- For loop
- While loop
- Continue and break
- Type hints
- F-strings
- Exception handling
