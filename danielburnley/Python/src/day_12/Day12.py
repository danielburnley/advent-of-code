from typing import List
from enum import Enum


class AssembunnyInstructions(Enum):
    copy = "cpy"
    increment = "inc"
    decrement = "dec"
    jumpNoZero = "jnz"


class AssembunnyRunner:
    def __init__(self):
        self.stack = []  # type: List[str]
        self.pointer = 0
        self.registers = {'a': 0, 'b': 0, 'c': 0, 'd': 0}

    def execute_next_instruction(self):
        instruction = self.stack[self.pointer].split(" ")
        if instruction[0] == AssembunnyInstructions.copy.value:
            if instruction[1] in self.registers:
                self.registers[instruction[2]] = self.registers[instruction[1]]
            else:
                self.registers[instruction[2]] = int(instruction[1])
            self.pointer += 1
        elif instruction[0] == AssembunnyInstructions.increment.value:
            self.registers[instruction[1]] += 1
            self.pointer += 1
        elif instruction[0] == AssembunnyInstructions.decrement.value:
            self.registers[instruction[1]] -= 1
            self.pointer += 1
        elif instruction[0] == AssembunnyInstructions.jumpNoZero.value:
            try:
                if self.registers[instruction[1]] != 0:
                    self.pointer += int(instruction[2])
                else:
                    self.pointer += 1
            except KeyError:
                if int(instruction[1]) != 0:
                    self.pointer += int(instruction[2])
                else:
                    self.pointer += 1

    def add_instruction(self, instruction):
        self.stack.append(instruction)

    def execute(self):
        while self.pointer < len(self.stack):
            self.execute_next_instruction()
