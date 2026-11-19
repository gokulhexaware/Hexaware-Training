class Node:
    def __init__(self, code):
        self.code = code
        self.left = None
        self.right = None
def insert(root, code):
    if root is None:
        return Node(code)
    if code < root.code:
        root.left = insert(root.left, code)
    elif code > root.code:
        root.right = insert(root.right, code)
    return root
def search(root, code):
    if root is None or root.code == code:
        return root
    if code < root.code:
        return search(root.left, code)
    return search(root.right, code)
def height(root):
    if root is None:
        return -1
    return 1 + max(height(root.left), height(root.right))
def inorder(root):
    if root is None:
        return []
    return inorder(root.left) + [root.code] + inorder(root.right)
hub_codes = ["H50", "H30", "H70", "H20", "H40", "H60", "H80"]
root = None
for code in hub_codes:
    root = insert(root, code)
print("Hub codes in sorted order:", inorder(root))
print("Search H40:", "Found" if search(root, "H40") else "Not found")
print("Search H90:", "Found" if search(root, "H90") else "Not found")
print("Tree height:", height(root))
sorted_codes = ["H10", "H20", "H30", "H40", "H50"]
sorted_root = None
for code in sorted_codes:
    sorted_root = insert(sorted_root, code)
print("Height with sorted insertion:", height(sorted_root))
print("Empty tree height:", height(None))
