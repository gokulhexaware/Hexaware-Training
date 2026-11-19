from collections import deque
# Custom Stack
class CustomStack:
    def __init__(self):
        self.items = []
    def push(self, item):
        self.items.append(item)
    def pop(self):
        if self.is_empty():
            return None
        return self.items.pop()
    def peek(self):
        if self.is_empty():
            return None
        return self.items[-1]
    def is_empty(self):
        return len(self.items) == 0
# Custom Queue
class CustomQueue:
    def __init__(self):
        self.items = []
    def enqueue(self, item):
        self.items.append(item)
    def dequeue(self):
        if self.is_empty():
            return None
        return self.items.pop(0)
    def is_empty(self):
        return len(self.items) == 0
# Custom Stack Demonstration
print("--- Custom Stack ---")
stack = CustomStack()
stack.push("Order 101 edited")
stack.push("Order 102 edited")
stack.push("Order 103 edited")
print("Undo:", stack.pop())
print("Remaining Stack:", stack.items)
# Custom Queue Demonstration
print("\n--- Custom Queue ---")
queue = CustomQueue()
queue.enqueue("Order 101")
queue.enqueue("Order 102")
queue.enqueue("Order 103")
print("Dispatching:", queue.dequeue())
print("Remaining Queue:", queue.items)
# Built-in Stack using List
print("\n--- Built-in Stack ---")
builtin_stack = []
builtin_stack.append("Order 101 edited")
builtin_stack.append("Order 102 edited")
builtin_stack.append("Order 103 edited")
print("Undo:", builtin_stack.pop())
print("Remaining Stack:", builtin_stack)
# Built-in Queue using Deque
print("\n--- Built-in Queue ---")
builtin_queue = deque()
builtin_queue.append("Order 101")
builtin_queue.append("Order 102")
builtin_queue.append("Order 103")
print("Dispatching:", builtin_queue.popleft())
print("Remaining Queue:", list(builtin_queue))