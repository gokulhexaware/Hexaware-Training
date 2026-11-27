
from dataclasses import dataclass
@dataclass
class Applicant:
    name: str
    age: int
    monthly_income: float
    monthly_emi: float
    credit_score: int
    employment_type: str
    existing_loans: int
@dataclass
class Decision:
    name: str
    status: str
    credit_band: str
    interest_rate: float
    loan_product: str
    reasons: str
def validate_applicant(applicant: Applicant) -> str:
    if applicant.age < 0:
        return f"Invalid age: {applicant.age}"
    if applicant.monthly_income <= 0:
        return f"Invalid income: {applicant.monthly_income}"
    if applicant.monthly_emi < 0:
        return f"Invalid EMI: {applicant.monthly_emi}"
    if applicant.credit_score < 300 or applicant.credit_score > 850:
        return f"Invalid credit score: {applicant.credit_score}"
    if applicant.existing_loans < 0:
        return f"Invalid existing loans: {applicant.existing_loans}"
    return ""
def get_credit_details(credit_score: int) -> tuple[str, float, str]:
    match credit_score:
        case score if score >= 750:
            return "Excellent", 8.5, "Premium Personal Loan"
        case score if score >= 700:
            return "Good", 9.5, "Standard Personal Loan"
        case score if score >= 650:
            return "Fair", 11.5, "Secured Personal Loan"
        case _:
            return "Poor", 0.0, "Not Eligible"
def evaluate_applicant(applicant: Applicant) -> Decision:
    age_eligible: bool = 21 <= applicant.age <= 60
    income_to_emi_ratio: float = applicant.monthly_emi / applicant.monthly_income
    income_eligible: bool = income_to_emi_ratio <= 0.40
    credit_band: str
    interest_rate: float
    loan_product: str
    credit_band, interest_rate, loan_product = get_credit_details(applicant.credit_score)
    credit_eligible: bool = applicant.credit_score >= 650
    employment_eligible: bool = applicant.employment_type.lower() in ("salaried", "self-employed")
    existing_loan_eligible: bool = applicant.existing_loans <= 2
    reasons: list[str] = []
    if not age_eligible:
        reasons.append("Age outside 21-60")
    if not income_eligible:
        reasons.append("EMI exceeds 40% of income")
    if not credit_eligible:
        reasons.append("Credit score below 650")
    if not employment_eligible:
        reasons.append("Employment type not accepted")
    if not existing_loan_eligible:
        reasons.append("More than 2 existing loans")
    if age_eligible:
        if income_eligible and credit_eligible:
            if employment_eligible and existing_loan_eligible:
                status: str = "APPROVED"
            else:
                status = "REJECTED"
        else:
            status = "REJECTED"
    else:
        status = "REJECTED"
    if status == "APPROVED":
        reason_text: str = "All eligibility rules passed"
    else:
        reason_text = ", ".join(reasons)
    return Decision(applicant.name, status, credit_band, interest_rate, loan_product, reason_text)
def process_applicants(applicants: list[Applicant], daily_approval_limit: int) -> list[Decision]:
    decisions: list[Decision] = []
    approvals: int = 0
    for applicant in applicants:
        validation_error: str = validate_applicant(applicant)
        if validation_error:
            print(f"Invalid record skipped: {applicant.name} - {validation_error}")
            continue
        decision: Decision = evaluate_applicant(applicant)
        decisions.append(decision)
        if decision.status == "APPROVED":
            approvals += 1
            if approvals >= daily_approval_limit:
                print(f"Daily approval limit of {daily_approval_limit} reached. Stopping processing.")
                break
    else:
        print(f"All applicant records processed. Total approvals: {approvals}")
    return decisions
def get_applicants() -> list[Applicant]:
    applicants: list[Applicant] = [
        Applicant("Aarav", 30, 80000, 20000, 780, "Salaried", 1),
        Applicant("Diya", 28, 0, 10000, 740, "Salaried", 0),
        Applicant("Rohan", 19, 50000, 10000, 720, "Salaried", 1),
        Applicant("Meera", 42, 90000, 25000, 720, "Self-Employed", 2),
        Applicant("Kabir", 35, 60000, 15000, 620, "Salaried", 1),
        Applicant("Anaya", -5, 50000, 10000, 750, "Salaried", 0),
        Applicant("Ishaan", 32, 50000, 25000, 760, "Salaried", 1),
        Applicant("Sara", 65, 85000, 20000, 790, "Salaried", 0),
        Applicant("Vikram", 40, 70000, 15000, 740, "Unemployed", 1),
        Applicant("Nisha", 29, 60000, 10000, 900, "Salaried", 0)
    ]
    return applicants
