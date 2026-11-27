from main import Applicant, get_applicants, process_applicants, validate_applicant
def display_decision_table(decisions: list) -> None:
    print(f"\n{'NAME':<12}{'STATUS':<12}{'CREDIT BAND':<15}{'RATE':<10}{'LOAN PRODUCT':<28}{'REASON'}")
    print(f"{'-' * 110}")
    for decision in decisions:
        print(f"{decision.name:<12}{decision.status:<12}{decision.credit_band:<15}{decision.interest_rate:<10.2f}{decision.loan_product:<28}{decision.reasons}")
def test_edge_cases() -> None:
    print(f"\n{'EDGE CASE TESTING'}")
    test_applicants: list[Applicant] = [
        Applicant("ZeroIncome", 30, 0, 10000, 750, "Salaried", 0),
        Applicant("NegativeAge", -2, 50000, 10000, 750, "Salaried", 0),
        Applicant("HighScore", 30, 50000, 10000, 900, "Salaried", 0)
    ]
    for applicant in test_applicants:
        error: str = validate_applicant(applicant)
        print(f"Applicant: {applicant.name:<15} Validation: {error}")
def main() -> None:
    applicants: list[Applicant] = get_applicants()
    print(f"\n{'LOAN ELIGIBILITY ENGINE'}")
    print(f"{'=' * 110}")
    print(f"Total applicants received: {len(applicants)}")
    decisions: list = process_applicants(applicants, 3)
    display_decision_table(decisions)
    print(f"\n{'BREAK CONDITION DEMONSTRATION'}")
    process_applicants([applicants[0]], 1)
    test_edge_cases()
if __name__ == "__main__":
    main()
