order_values = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
gift_card_value = 100
left = 0
right = len(order_values) - 1
pairs = []
while left < right:
    current_sum = order_values[left] + order_values[right]

    if current_sum == gift_card_value:
        pairs.append((order_values[left], order_values[right]))
        left += 1
        right -= 1
    elif current_sum < gift_card_value:
        left += 1
    else:
        right -= 1
print("Gift-card value:", gift_card_value)
print("Matching order-value pairs:")
for first, second in pairs:
    print(f"{first} + {second} = {gift_card_value}")
