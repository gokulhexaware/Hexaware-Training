from dataclasses import dataclass
@dataclass
class Applicant:
    name: str
    age: int
    weight: float
    height: float
    smoker: bool
    policy_term: int
@dataclass
class PremiumResult:
    name: str
    bmi: float
    bmi_category: str
    bmi_loading: float
    smoker_loading: float
    base_premium: float
    final_premium: float
    status: str
def calculate_bmi(weight: float, height: float) -> float:
    if weight <= 0 or height <= 0:
        raise ValueError("Weight and height must be positive")
    bmi: float = weight / (height * height)
    return bmi
def classify_bmi(bmi: float) -> tuple[str, float]:
    if bmi < 18.5:
        if bmi < 16:
            category: str = "Underweight"
            loading: float = 5.0
        else:
            category = "Underweight"
            loading = 5.0
    elif bmi < 25:
        if bmi >= 18.5:
            category = "Normal"
            loading = 0.0
    elif bmi < 30:
        if bmi >= 25:
            category = "Overweight"
            loading = 10.0
    else:
        if bmi >= 30:
            category = "Obese"
            loading = 20.0
    return category, loading
def get_base_premium(age: int, policy_term: int) -> float:
    match (age, policy_term):
        case (a, t) if 18 <= a <= 30 and t == 10:
            return 5000.0
        case (a, t) if 18 <= a <= 30 and t == 20:
            return 8000.0
        case (a, t) if 18 <= a <= 30 and t == 30:
            return 11000.0
        case (a, t) if 31 <= a <= 45 and t == 10:
            return 7000.0
        case (a, t) if 31 <= a <= 45 and t == 20:
            return 10000.0
        case (a, t) if 31 <= a <= 45 and t == 30:
            return 14000.0
        case (a, t) if 46 <= a <= 60 and t == 10:
            return 10000.0
        case (a, t) if 46 <= a <= 60 and t == 20:
            return 15000.0
        case (a, t) if 46 <= a <= 60 and t == 30:
            return 20000.0
        case _:
            return 0.0
def calculate_premium(applicant: Applicant) -> PremiumResult:
    if not 18 <= applicant.age <= 60:
        return PremiumResult(applicant.name, 0.0, "Not Applicable", 0.0, 0.0, 0.0, 0.0, "INELIGIBLE")
    if applicant.policy_term not in (10, 20, 30):
        return PremiumResult(applicant.name, 0.0, "Not Applicable", 0.0, 0.0, 0.0, 0.0, "INELIGIBLE")
    bmi: float = calculate_bmi(applicant.weight, applicant.height)
    bmi_category: str
    bmi_loading: float
    bmi_category, bmi_loading = classify_bmi(bmi)
    smoker_loading: float = 25.0 if applicant.smoker else 0.0
    base_premium: float = get_base_premium(applicant.age, applicant.policy_term)
    final_premium: float = base_premium * (1 + bmi_loading / 100 + smoker_loading / 100)
    return PremiumResult(applicant.name, bmi, bmi_category, bmi_loading, smoker_loading, base_premium, final_premium, "ELIGIBLE")
def get_applicants() -> list[Applicant]:
    applicants: list[Applicant] = [
        Applicant("Aarav", 25, 65, 1.75, False, 10),
        Applicant("Diya", 35, 58, 1.60, True, 20),
        Applicant("Rohan", 48, 85, 1.70, False, 10),
        Applicant("Meera", 29, 45, 1.65, False, 30),
        Applicant("Kabir", 55, 95, 1.75, True, 20),
        Applicant("Anaya", 42, 70, 1.60, False, 10),
        Applicant("Ishaan", 65, 72, 1.72, False, 20),
        Applicant("Sara", 32, 80, 1.68, True, 30)
    ]
    return applicants
def display_results(applicants: list[Applicant]) -> None:
    print(f"\n{'INSURANCE PREMIUM RESULTS':^105}")
    print(f"{'NAME':<12}{'BMI':>9}{'CATEGORY':<16}{'BMI LOAD':>12}{'SMOKER LOAD':>14}{'BASE PREMIUM':>17}{'FINAL PREMIUM':>18}{'STATUS':>12}")
    print(f"{'-' * 110}")
    for applicant in applicants:
        result: PremiumResult = calculate_premium(applicant)
        print(f"{result.name:<12}{result.bmi:>9.2f}{result.bmi_category:<16}{result.bmi_loading:>11.2f}%{result.smoker_loading:>13.2f}%{result.base_premium:>17.2f}{result.final_premium:>18.2f}{result.status:>12}")
def batch_validation(applicants: list[Applicant]) -> None:
    print(f"\n{'BATCH VALIDATION':^60}")
    for applicant in applicants:
        if not 18 <= applicant.age <= 60:
            print(f"Ineligible applicant found: {applicant.name}, Age: {applicant.age}")
            print(f"Batch validation stopped.")
            break
        if applicant.policy_term not in (10, 20, 30):
            print(f"Ineligible policy term found for: {applicant.name}")
            print(f"Batch validation stopped.")
            break
    else:
        print(f"All applicants passed batch validation.")
def demonstrate_all_valid(applicants: list[Applicant]) -> None:
    print(f"\n{'ALL-VALID BATCH TEST':^60}")
    valid_applicants: list[Applicant] = [
        applicant for applicant in applicants
        if 18 <= applicant.age <= 60 and applicant.policy_term in (10, 20, 30)
    ]
    for applicant in valid_applicants:
        print(f"Validated applicant: {applicant.name}")
    else:
        print(f"All {len(valid_applicants)} applicants are valid.")
def demonstrate_conversion_errors() -> None:
    print(f"\n{'TYPE CONVERSION ERROR HANDLING':^60}")
    test_inputs: list[str] = ["25", "abc", ""]
    for value in test_inputs:
        try:
            converted_age: int = int(value)
            print(f"Input: {value!r:<8} Converted age: {converted_age}")
        except ValueError:
            if value == "":
                print(f"Input: {value!r:<8} Error: Empty input cannot be converted to integer.")
            else:
                print(f"Input: {value!r:<8} Error: Invalid string cannot be converted to integer.")
def main() -> None:
    applicants: list[Applicant] = get_applicants()
    print(f"{'INSURANCE PREMIUM BANDS':^60}")
    print(f"{'=' * 60}")
    print(f"Total applicants received: {len(applicants)}")
    display_results(applicants)
    batch_validation(applicants)
    demonstrate_all_valid(applicants)
    demonstrate_conversion_errors()
if __name__ == "__main__":
    main()
