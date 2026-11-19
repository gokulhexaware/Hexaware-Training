
class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

def insert(root, value):
    if root is None:
        return Node(value)
    if value < root.value:
        root.left = insert(root.left, value)
    elif value > root.value:
        root.right = insert(root.right, value)
    return root

def search(root, value):
    if root is None or root.value == value:
        return root
    if value < root.value:
        return search(root.left, value)
    return search(root.right, value)

def inorder(root):
    if root:
        inorder(root.left)
        print(root.value, end=" ")
        inorder(root.right)

def preorder(root):
    if root:
        print(root.value, end=" ")
        preorder(root.left)
        preorder(root.right)

def postorder(root):
    if root:
        postorder(root.left)
        postorder(root.right)
        print(root.value, end=" ")

categories = ["Electronics", "Books", "Clothing", "Home", "Sports", "Mobiles", "Laptops", "Fiction", "Non-Fiction", "Men", "Women", "Furniture", "Kitchen", "Fitness", "Outdoor"]
root = None
for category in categories:
    root = insert(root, category)

print("Inorder:")
inorder(root)
print("\nPreorder:")
preorder(root)
print("\nPostorder:")
postorder(root)
print("\nSearch for Mobiles:", "Found" if search(root, "Mobiles") else "Not found")
print("Search for Toys:", "Found" if search(root, "Toys") else "Not found")
