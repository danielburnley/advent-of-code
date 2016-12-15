from collections import deque


class Day8:
    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.screen = self.generate_screen(width, height)

    def generate_screen(self, width: int, height: int) -> list:
        return [["." for _ in range(width)] for _ in range(height)]

    def draw_rect(self, width, height):
        for i in range(height):
            for j in range(width):
                self.screen[i][j] = "#"

    def rotate_x(self, row, amount):
        self.screen[row] = list(deque(self.screen[row]).rotate(amount))

    def rotate_y(self, col, amount):
        col_deque = deque([row[col] for row in self.screen])
        col_deque.rotate(amount)
        for i in range(len(col_deque)):
            self.screen[i][col] = col_deque[i]

    def parse_command(self, command: str):
        command = command.split(" ")
        if command[0] == "rect":
            dimensions = command[1].split("x")
            self.draw_rect(int(dimensions[0]), int(dimensions[1]))
        elif command[0] == "rotate":
            if command[1] == "row":
                self.rotate_x(int(command[2][2:]), int(command[4]))
            elif command[1] == "column":
                self.rotate_y(int(command[2][2:]), int(command[4]))

    def count_on_pixels(self) -> int:
        count = 0
        for row in self.screen:
            for col in row:
                if col == "#":
                    count += 1
        return count

    def run_commands(self, commands: list):
        for command in commands:
            self.parse_command(command)

    # Part B

    def print_screen(self):
        screen_copy = [[x if x == "#" else " " for x in row] for row in self.screen]
        for row in screen_copy:
            print("".join(row))
