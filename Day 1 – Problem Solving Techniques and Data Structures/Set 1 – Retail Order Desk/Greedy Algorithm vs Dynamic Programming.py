# Greedy Algorithm
def greedy_change(coins, amount):
    coins = sorted(coins, reverse=True)
    result = []
    for coin in coins:
        while amount >= coin:
            amount -= coin
            result.append(coin)
    if amount != 0:
        return None
    return result
# Dynamic Programming
def minimum_coins(coins, amount):
    dp = [float("inf")] * (amount + 1)
    dp[0] = 0
    for value in range(1, amount + 1):
        for coin in coins:
            if value >= coin:
                dp[value] = min(
                    dp[value],
                    dp[value - coin] + 1
                )
    if dp[amount] == float("inf"):
        return None
    # Reconstruct selected coins
    result = []
    remaining = amount
    while remaining > 0:
        for coin in coins:
            if (
                remaining >= coin
                and dp[remaining] == dp[remaining - coin] + 1
            ):
                result.append(coin)
                remaining -= coin
                break
    return result
# Main Program
coins = [4, 3, 1]
amount = 6
greedy_result = greedy_change(coins, amount)
dp_result = minimum_coins(coins, amount)
print("--- Greedy Algorithm ---")
print("Selected Coins:", greedy_result)
print("Number of Coins:", len(greedy_result))
print("\n--- Dynamic Programming ---")
print("Selected Coins:", dp_result)
print("Number of Coins:", len(dp_result))