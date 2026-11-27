Set 1 - Loan Eligibility Engine

Eligibility Rules

1. Age must be between 21 and 60.
2. Monthly EMI must not exceed 40% of monthly income.
3. Credit score must be at least 650.
4. Employment must be Salaried or Self-Employed.
5. Existing loans must not exceed 2.
6. All six eligibility conditions must pass for approval.

Credit Score Bands

- 750-850: Excellent - 8.5% - Premium Personal Loan
- 700-749: Good - 9.5% - Standard Personal Loan
- 650-699: Fair - 11.5% - Secured Personal Loan
- Below 650: Poor - Not Eligible

Test Cases

| Applicant | Test Condition | Expected Result |
|---|---|---|
| Aarav | All conditions satisfied | APPROVED |
| Diya | Zero income | INVALID |
| Rohan | Age below 21 | REJECTED |
| Meera | All conditions satisfied | APPROVED |
| Kabir | Credit score below 650 | REJECTED |
| Anaya | Negative age | INVALID |
| Ishaan | EMI exceeds 40% | REJECTED |
| Sara | Age above 60 | REJECTED |
| Vikram | Unaccepted employment | REJECTED |
| Nisha | Credit score above 850 | INVALID |

Edge Cases

- Zero income: Invalid record.
- Negative age: Invalid record.
- Credit score above 850: Invalid record.
- Credit score below 300: Invalid record.
- EMI greater than income: Rejected by the EMI eligibility rule.

Loop Conditions

- Continue skips invalid applicant records.
- Break stops processing when the daily approval limit is reached.
- Loop else displays a message when all records are processed without break.

Technology

- Python 3.13
- Dataclasses
- Type hints
- If-elif and nested conditions
- Match/case
- For loop
- Continue, break and loop-else
- F-strings
