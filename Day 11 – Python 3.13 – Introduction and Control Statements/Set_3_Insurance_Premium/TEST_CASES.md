Set 3 - Insurance Premium Bands

BMI Classification

- Below 18.5: Underweight - 5% loading
- 18.5 to 24.9: Normal - 0% loading
- 25 to 29.9: Overweight - 10% loading
- 30 and above: Obese - 20% loading

Additional Loading

- Smoker: 25%
- Non-smoker: 0%

Base Premium

| Age Band | 10 Years | 20 Years | 30 Years |
|---|---:|---:|---:|
| 18-30 | Rs. 5000 | Rs. 8000 | Rs. 11000 |
| 31-45 | Rs. 7000 | Rs. 10000 | Rs. 14000 |
| 46-60 | Rs. 10000 | Rs. 15000 | Rs. 20000 |

Applicant Test Cases

| Applicant | Age | Expected Result |
|---|---:|---|
| Aarav | 25 | Eligible |
| Diya | 35 | Eligible |
| Rohan | 48 | Eligible |
| Meera | 29 | Eligible |
| Kabir | 55 | Eligible |
| Anaya | 42 | Eligible |
| Ishaan | 65 | Ineligible |
| Sara | 32 | Eligible |

BMI Test Cases

| BMI | Expected Category |
|---:|---|
| 17.0 | Underweight |
| 22.0 | Normal |
| 27.0 | Overweight |
| 32.0 | Obese |

Policy Term Test Cases

- 10 years: Valid
- 20 years: Valid
- 30 years: Valid
- 15 years: Invalid

Type Conversion Tests

| Input | Operation | Expected Result |
|---|---|---|
| "25" | int("25") | 25 |
| "abc" | int("abc") | ValueError |
| "" | int("") | ValueError |

Batch Validation

- The program processes eight applicant records for individual premium results.
- Batch validation uses break when an ineligible applicant is found.
- The loop else clause executes when all applicants pass validation.
- A separate all-valid batch demonstrates the loop else condition.

Technology

- Python 3.13
- Dataclasses
- Type hints
- BMI calculation
- Nested if statements
- Match/case with guards
- Arithmetic, comparison and logical operators
- For loop
- Break and loop-else
- Type conversion
- Exception handling
- F-strings
