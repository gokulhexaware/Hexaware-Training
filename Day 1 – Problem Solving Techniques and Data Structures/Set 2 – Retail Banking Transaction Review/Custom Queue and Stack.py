from collections import deque
class CustomQueue:
    def __init__(self):
        self.items = []
    def enqueue(self, transaction):
        self.items.append(transaction)
    def dequeue(self):
        if self.is_empty():
            return None
        return self.items.pop(0)
    def is_empty(self):
        return len(self.items) == 0
class CustomStack:
    def __init__(self):
        self.items = []
    def push(self, adjustment):
        self.items.append(adjustment)
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
# Custom Queue Demonstration
print("--- Custom Queue ---")
review_queue = CustomQueue()
review_queue.enqueue("Transaction 101")
review_queue.enqueue("Transaction 102")
review_queue.enqueue("Transaction 103")
print("Reviewing:", review_queue.dequeue())
print("Remaining Queue:", review_queue.items)
# Custom Stack Demonstration
print("\n--- Custom Stack ---")
adjustment_stack = CustomStack()
adjustment_stack.push("Adjustment 500")
adjustment_stack.push("Adjustment 1000")
adjustment_stack.push("Adjustment 1500")

print("Reversing:", adjustment_stack.pop())
print("Remaining Stack:", adjustment_stack.items)
# Built-in Queue
print("\n--- Built-in Queue ---")

builtin_queue = deque()

builtin_queue.append("Transaction 101")
builtin_queue.append("Transaction 102")
builtin_queue.append("Transaction 103")
print("Reviewing:", builtin_queue.popleft())
print("Remaining Queue:", list(builtin_queue))
# Built-in Stack
print("\n--- Built-in Stack ---")

builtin_stack = []

builtin_stack.append("Adjustment 500")
builtin_stack.append("Adjustment 1000")
builtin_stack.append("Adjustment 1500")
print("Reversing:", builtin_stack.pop())
print("Remaining Stack:", builtin_stack)