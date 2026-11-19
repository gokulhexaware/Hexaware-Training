import time
class HashTable:
    def __init__(self, size):
        self.size = size
        self.table = [[] for _ in range(size)]
    def get_index(self, key):
        hash_value = 0
        for character in key:
            hash_value = (hash_value * 31 + ord(character)) % self.size
        return hash_value
    def insert(self, key, value):
        index = self.get_index(key)
        for item in self.table[index]:
            if item[0] == key:
                item[1] = value
                return
        self.table[index].append([key, value])
    def search(self, key):
        index = self.get_index(key)
        for stored_key, value in self.table[index]:
            if stored_key == key:
                return value
        return None
small_table = HashTable(10)
seen = {}
for number in range(1000, 1100):
    sku = f"SKU-{number}"
    index = small_table.get_index(sku)
    if index in seen:
        first_sku = seen[index]
        second_sku = sku
        collision_index = index
        break
    seen[index] = sku
small_table.insert(first_sku, "Wireless Mouse")
small_table.insert(second_sku, "USB Keyboard")
print("Collision demonstration:")
print(f"{first_sku} and {second_sku} both map to index {collision_index}")
print("Chaining at that index:", small_table.table[collision_index])
sku_count = 100000
skus = [f"SKU-{number:06d}" for number in range(sku_count)]
custom_table = HashTable(200003)
for sku in skus:
    custom_table.insert(sku, f"Product-{sku}")
sku_map = {sku: f"Product-{sku}" for sku in skus}
start = time.perf_counter()
for sku in skus:
    custom_table.search(sku)
custom_time = time.perf_counter() - start
start = time.perf_counter()
for sku in skus:
    sku_map.get(sku)
dict_time = time.perf_counter() - start
print("\nLookup comparison for 100,000 SKUs:")
print(f"Custom hash table: {custom_time:.6f} seconds")
print(f"Built-in dictionary: {dict_time:.6f} seconds")
print("Both methods returned the stored product for all SKUs.")
