def is_palindrome_route(route):
    cleaned = "".join(character.casefold() for character in route if character.isalnum())
    left = 0
    right = len(cleaned) - 1
    while left < right:
        if cleaned[left] != cleaned[right]:
            return False
        left += 1
        right -= 1
    return True
route_one = "H01 -> H02 -> H03 -> H02 -> H01"
route_two = "H01 -> H02 -> H03 -> H04"
route_three = "h01, h02, h01"
print("Route one:", "Palindrome" if is_palindrome_route(route_one) else "Not a palindrome")
print("Route two:", "Palindrome" if is_palindrome_route(route_two) else "Not a palindrome")
print("Route three:", "Palindrome" if is_palindrome_route(route_three) else "Not a palindrome")
print("Empty route:", is_palindrome_route(""))
print("Single hub:", is_palindrome_route("H01"))
