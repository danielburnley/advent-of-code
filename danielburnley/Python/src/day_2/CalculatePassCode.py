class CalculatePassCode:
    def __init__(self, key_pad: list, start_location: list):
        self.key_pad = key_pad
        self.currentKey = start_location

    def is_next_key_valid(self, next_key):
        is_not_minus_one = not self.key_pad[next_key[0]][next_key[1]] == -1
        row_is_within_range = next_key[0] > -1 and next_key[0] < len(self.key_pad)
        column_is_within_range = next_key[1] > -1 and next_key[1] < len(self.key_pad[0])
        return is_not_minus_one and row_is_within_range and column_is_within_range

    def move_key(self, step):
        try:
            if step == "U":
                nextKey = [self.currentKey[0] - 1, self.currentKey[1]]
            elif step == "D":
                nextKey = [self.currentKey[0] + 1, self.currentKey[1]]
            elif step == "L":
                nextKey = [self.currentKey[0], self.currentKey[1] - 1]
            else:
                nextKey = [self.currentKey[0], self.currentKey[1] + 1]
            if self.is_next_key_valid(nextKey):
                self.currentKey = nextKey
        except:
            pass

    def execute(self, instructions: str) -> str:
        instructions = instructions.split("\n")
        passCode = ""
        for instruction in instructions:
            for step in instruction:
                self.move_key(step)
            passCode += self.key_pad[self.currentKey[0]][self.currentKey[1]]
        return passCode
