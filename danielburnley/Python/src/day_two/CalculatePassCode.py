KEY_PAD = [['1', '2', '3'],
           ['4', '5', '6'],
           ['7', '8', '9']]


class CalculatePassCode:
    def __init__(self):
        self.currentKey = [1, 1]

    def move_key(self, step):
        if step == "U":
            self.currentKey[0] -= 1 if self.currentKey[0] > 0 else 0
        elif step =="D":
            self.currentKey[0] += 1 if self.currentKey[0] < 2 else 0
        elif step == "L":
            self.currentKey[1] -= 1 if self.currentKey[1] > 0 else 0
        elif step == "R":
            self.currentKey[1] += 1 if self.currentKey[1] < 2 else 0

    def execute(self, instructions: str) -> str:
        instructions = instructions.split("\n")
        # instructions.pop()
        passCode = ""
        for instruction in instructions:
            for step in instruction:
                self.move_key(step)
            passCode += KEY_PAD[self.currentKey[0]][self.currentKey[1]]
        return passCode
