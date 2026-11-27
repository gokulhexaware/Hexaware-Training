def calculate_energy_charge(units: float) -> float:
    if units < 0:
        raise ValueError("Units cannot be negative")
    if units <= 100:
        energy_charge: float = units * 1.50
    elif units <= 200:
        energy_charge = (100 * 1.50) + ((units - 100) * 2.50)
    elif units <= 400:
        energy_charge = (100 * 1.50) + (100 * 2.50) + ((units - 200) * 4.00)
    else:
        energy_charge = (100 * 1.50) + (100 * 2.50) + (200 * 4.00) + ((units - 400) * 6.00)
    return energy_charge
def get_fixed_charge(category: str) -> float:
    match category.lower():
        case "domestic":
            return 50.00
        case "commercial":
            return 150.00
        case "industrial":
            return 300.00
        case _:
            raise ValueError("Invalid consumer category")
def calculate_bill(units: float, category: str, is_late: bool = False, is_online: bool = False) -> dict[str, float]:
    if units < 0:
        raise ValueError("Units cannot be negative")
    energy_charge: float = calculate_energy_charge(units)
    fixed_charge: float = get_fixed_charge(category)
    subtotal: float = energy_charge + fixed_charge
    surcharge_rate: float = 0.05
    rebate_rate: float = 0.02
    surcharge: float = subtotal * surcharge_rate if is_late else 0.0
    rebate: float = subtotal * rebate_rate if is_online else 0.0
    # Parentheses make the conditional calculations clear before addition and subtraction.
    total: float = subtotal + (subtotal * surcharge_rate if is_late else 0.0) - (subtotal * rebate_rate if is_online else 0.0)
    return {
        "units": units,
        "energy_charge": energy_charge,
        "fixed_charge": fixed_charge,
        "subtotal": subtotal,
        "surcharge": surcharge,
        "rebate": rebate,
        "total": total
    }
def print_bill(units: float, category: str, is_late: bool = False, is_online: bool = False) -> None:
    bill: dict[str, float] = calculate_bill(units, category, is_late, is_online)
    print(f"\n{'ELECTRICITY BILL':^45}")
    print(f"{'=' * 45}")
    print(f"{'Consumer Category':<25}: {category.title():>15}")
    print(f"{'Units Consumed':<25}: {bill['units']:>15.2f}")
    print(f"{'Energy Charge':<25}: Rs. {bill['energy_charge']:>12.2f}")
    print(f"{'Fixed Charge':<25}: Rs. {bill['fixed_charge']:>12.2f}")
    print(f"{'Subtotal':<25}: Rs. {bill['subtotal']:>12.2f}")
    print(f"{'Late Surcharge':<25}: Rs. {bill['surcharge']:>12.2f}")
    print(f"{'Online Rebate':<25}: Rs. {bill['rebate']:>12.2f}")
    print(f"{'=' * 45}")
    print(f"{'Final Amount':<25}: Rs. {bill['total']:>12.2f}")
    print(f"{'=' * 45}")
def display_monthly_statement() -> None:
    months: list[str] = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ]
    consumption: list[float] = [85, 120, 150, 180, 220, 260, 300, 350, 390, 410, 450, 500]
    category: str = "domestic"
    print(f"\n{'12-MONTH CONSUMPTION STATEMENT':^65}")
    print(f"{'MONTH':<15}{'UNITS':>10}{'ENERGY CHARGE':>18}{'TOTAL BILL':>18}")
    print(f"{'-' * 65}")
    for month, units in zip(months, consumption):
        bill: dict[str, float] = calculate_bill(units, category)
        print(f"{month:<15}{units:>10.2f}{bill['energy_charge']:>18.2f}{bill['total']:>18.2f}")
    print(f"{'-' * 65}")
def accept_readings() -> None:
    print(f"\n{'INTERACTIVE BILLING SYSTEM'}")
    print(f"{'Enter q to stop entering readings.'}")
    category: str = input("Enter consumer category (domestic/commercial/industrial): ").strip().lower()
    try:
        get_fixed_charge(category)
    except ValueError as error:
        print(f"Error: {error}")
        return
    while True:
        reading: str = input("\nEnter electricity consumption units or q to quit: ").strip()
        if reading.lower() == "q":
            print(f"Billing session ended.")
            break
        try:
            units: float = float(reading)
            if units < 0:
                print(f"Invalid reading: Units cannot be negative.")
                continue
            late_input: str = input("Is the payment late? (yes/no): ").strip().lower()
            online_input: str = input("Is this an online payment? (yes/no): ").strip().lower()
            if late_input not in ("yes", "no") or online_input not in ("yes", "no"):
                print(f"Invalid payment option. Enter yes or no.")
                continue
            is_late: bool = late_input == "yes"
            is_online: bool = online_input == "yes"
            print_bill(units, category, is_late, is_online)
        except ValueError:
            print(f"Invalid reading: Please enter a valid number.")
def display_boundary_tests() -> None:
    boundary_values: list[float] = [100, 101, 200, 201, 400, 401]
    print(f"\n{'BOUNDARY TEST RESULTS':^65}")
    print(f"{'UNITS':<15}{'ENERGY CHARGE':>20}{'DOMESTIC BILL':>20}")
    print(f"{'-' * 55}")
    for units in boundary_values:
        bill: dict[str, float] = calculate_bill(units, "domestic")
        print(f"{units:<15.2f}{bill['energy_charge']:>20.2f}{bill['total']:>20.2f}")
def main() -> None:
    print(f"{'UTILITY BILLING CALCULATOR':^65}")
    print(f"{'=' * 65}")
    print_bill(150, "domestic", False, True)
    print_bill(250, "commercial", True, False)
    print_bill(450, "industrial", True, True)
    display_boundary_tests()
    display_monthly_statement()
    accept_readings()
if __name__ == "__main__":
    main()
