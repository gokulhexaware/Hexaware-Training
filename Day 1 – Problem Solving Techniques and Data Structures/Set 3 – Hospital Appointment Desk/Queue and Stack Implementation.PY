class Queue:
    def __init__(self):
        self.items = []
        self.front = 0
    def enqueue(self, patient):
        self.items.append(patient)
    def dequeue(self):
        if self.is_empty():
            return "Queue is empty"
        patient = self.items[self.front]
        self.front += 1
        return patient
    def is_empty(self):
        return self.front >= len(self.items)
    def display(self):
        return self.items[self.front:]
class Stack:
    def __init__(self):
        self.items = []
    def push(self, patient):
        self.items.append(patient)
    def pop(self):
        if not self.items:
            return "Stack is empty"
        return self.items.pop()
    def peek(self):
        if not self.items:
            return "Stack is empty"
        return self.items[-1]
    def display(self):
        return self.items[::-1]
walkin_queue = Queue()
walkin_queue.enqueue("Patient_101")
walkin_queue.enqueue("Patient_102")
walkin_queue.enqueue("Patient_103")
print("Walk-in Queue:", walkin_queue.display())
print("Patient Served:", walkin_queue.dequeue())
print("Updated Queue:", walkin_queue.display())
viewed_history = Stack()
viewed_history.push("Patient_201")
viewed_history.push("Patient_202")
viewed_history.push("Patient_203")
print("Recent Patients Viewed:", viewed_history.display())
print("Last Viewed Patient:", viewed_history.pop())
print("Updated History:", viewed_history.display())