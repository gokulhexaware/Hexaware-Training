class Node:
    def __init__(self, claim_id):
        self.claim_id = claim_id
        self.left = None
        self.right = None
def insert(root, claim_id):
    if root is None:
        return Node(claim_id)
    if claim_id < root.claim_id:
        root.left = insert(root.left, claim_id)
    elif claim_id > root.claim_id:
        root.right = insert(root.right, claim_id)
    return root
def search(root, claim_id):
    if root is None or root.claim_id == claim_id:
        return root
    if claim_id < root.claim_id:
        return search(root.left, claim_id)
    return search(root.right, claim_id)
def inorder(root):
    if root is None:
        return []
    return inorder(root.left) + [root.claim_id] + inorder(root.right)
def preorder(root):
    if root is None:
        return []
    return [root.claim_id] + preorder(root.left) + preorder(root.right)
def postorder(root):
    if root is None:
        return []
    return postorder(root.left) + postorder(root.right) + [root.claim_id]
claim_ids = [105, 102, 108, 101, 104, 107, 110]
root = None
for claim_id in claim_ids:
    root = insert(root, claim_id)
print("Inorder:", inorder(root))
print("Preorder:", preorder(root))
print("Postorder:", postorder(root))
print("Search 104:", "Found" if search(root, 104) else "Not found")
print("Search 115:", "Found" if search(root, 115) else "Not found")
print("Empty tree:", inorder(None))
root = insert(root, 104)
print("After duplicate insertion:", inorder(root))
